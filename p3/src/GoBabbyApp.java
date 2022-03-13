import java.sql.*;
import java.util.*;

// IDK why baby has two Bs (Babby). I'm simply following the handout to get marks.
class GoBabbyApp {
    // I am setting userid and password as env variables.
    // Optionally, you can input them as plain text bellow.
    private final static String URL = "jdbc:db2://winter2022-comp421.cs.mcgill.ca:50000/cs421";
    private static String your_userid = null;
    private static String your_password = null;

    // Variables to hold SQLException code and state.
    private static int sqlCode = 0;
    private static String sqlState = "00000";

    // Since this is a small application, we will create a single connection
    // to the DB and close it at the end of the program. Creating a new connection
    // for queries will only introduce overhead in this context.
    private static Connection con;
    private static Statement statement;


    private static int pracId; // selected midwife practitioner id
    private static List<Map<String, Object>> rsList; // ArrayList copy of the result set
    private static Map<String, Object> selectedRow; // selected appointment/pregnancy


    private static final Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) throws SQLException {
        System.out.println("----- Go Babby Application ------");

        setupJDBC();
        startBabbyApp();
    }

    /**
     * Register the IBM DB2 driver, create a connection to the DB and a statement.
     *
     * @throws SQLException
     */
    private static void setupJDBC() throws SQLException {
        // Register the driver.
        try {
            DriverManager.registerDriver(new com.ibm.db2.jcc.DB2Driver());
        } catch (Exception cnfe) {
            System.out.println("Class not found");
            System.exit(1);
        }

        if (your_userid == null && (your_userid = System.getenv("SOCSUSER")) == null) {
            System.err.println("Error!! do not have a password to connect to the database!");
            System.exit(1);
        }
        if (your_password == null && (your_password = System.getenv("SOCSPASSWD")) == null) {
            System.err.println("Error!! do not have a password to connect to the database!");
            System.exit(1);
        }

        con = DriverManager.getConnection(URL, your_userid, your_password);
        statement = con.createStatement();
    }

    /**
     * Simply start the execution of the program by calling the first query method.
     *
     * @throws SQLException
     */
    private static void startBabbyApp() throws SQLException {
        authMidwife();
    }

    /**
     * Authenticate a midwife given their prac id.
     *
     * @throws SQLException
     */
    private static void authMidwife() throws SQLException {
        System.out.print("\nPlease enter your practitioner id [E] to exit: ");
        String input = scanner.nextLine();
        if (input.equalsIgnoreCase("e")) terminateBabbyApp(0);

        try {
            pracId = Integer.parseInt(input);
        } catch (NumberFormatException e) {
            System.out.println("The practitioner Id must be an integer");
            authMidwife();
        }

        try {
            String querySQL = """
                    SELECT PRACID, NAME
                    from MIDWIVES
                    WHERE PRACID = %d;
                    """.formatted(pracId);

            java.sql.ResultSet rs = statement.executeQuery(querySQL);

            if (rs.next()) {
                pracId = rs.getInt("PRACID");
                String name = rs.getString("NAME");
                System.out.println("Welcome " + name.split(" ")[0]);
            } else {
                System.out.println("Invalid practitioner id");
                authMidwife();
            }

        } catch (SQLException e) {
            sqlCode = e.getErrorCode();
            sqlState = e.getSQLState();

            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
            authMidwife();
        }
        listMidwifeAppointments();
    }

    /**
     * List the midwife's appointments given the appointment date.
     *
     * @throws SQLException
     */
    private static void listMidwifeAppointments() throws SQLException {
        System.out.print("\nPlease enter the date (YYYY-MM-DD) for appointment list [E] to exit: ");
        String input = scanner.nextLine();
        if (input.equalsIgnoreCase("e")) terminateBabbyApp(0);

        ResultSet rs;

        try {
            String querySQL = """
                    SELECT APPTID,
                           TIME,
                           m.NAME,
                           m.QCHCARDID,
                           APPOINTMENTS.COUPLEID,
                           P.PREGNUM,
                           CASE WHEN PRIMARYMIDWIFE = %d THEN 'P' ELSE 'B' END AS role
                    FROM APPOINTMENTS
                             JOIN COUPLES c ON c.COUPLEID = APPOINTMENTS.COUPLEID
                             JOIN MOTHERS m ON c.QCHCARDID = m.QCHCARDID
                             JOIN PREGNANCIES P ON APPOINTMENTS.PREGNUM = P.PREGNUM and APPOINTMENTS.COUPLEID = P.COUPLEID
                    WHERE PRACID = %d
                      AND DATE = '%s'
                    ORDER BY TIME;
                    """.formatted(pracId, pracId, input);

            rs = statement.executeQuery(querySQL);

            rsList = rsToList(rs);
            if (rsList.size() == 0) {
                System.out.printf("No appointment exists with date %s%n", input);
                listMidwifeAppointments();
            }
        } catch (SQLException e) {
            sqlCode = e.getErrorCode();
            sqlState = e.getSQLState();

            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
        }
        selectAppointment();
    }

    /**
     * Select an appointment from the list.
     *
     * @throws SQLException
     */
    private static void selectAppointment() throws SQLException {
        for (int i = 0; i < rsList.size(); i++) {
            System.out.printf("%d:\t%s %s %s %s%n",
                    i + 1,
                    rsList.get(i).get("TIME").toString(),
                    rsList.get(i).get("ROLE"),
                    rsList.get(i).get("NAME"),
                    rsList.get(i).get("QCHCARDID")
            );
        }

        System.out.print("""
                                
                Enter the appointment number that you would like to work on.
                        [E] to exit [D] to go back to another date:\040""");
        String input = scanner.nextLine();
        if (input.equalsIgnoreCase("e")) terminateBabbyApp(0);
        if (input.equalsIgnoreCase("d")) listMidwifeAppointments();

        int selection = -1;
        try {
            selection = Integer.parseInt(input) - 1;
        } catch (NumberFormatException e) {
            System.out.println("Selection must be an integer");
            selectAppointment();
        }

        try {
            selectedRow = rsList.get(selection);
        } catch (IndexOutOfBoundsException e) {
            System.out.println("Invalid selection");
            selectAppointment();
        }

        actOnAppointment();
    }

    /**
     * Act on the selected appointment by choosing on of the actions.
     *
     * @throws SQLException
     */
    private static void actOnAppointment() throws SQLException {
        assert selectedRow != null;
        System.out.printf("""
                                
                For %s %s
                        
                1. Review notes
                2. Review tests
                3. Add a note
                4. Prescribe a test
                5. Go back to the appointments
                        
                Enter your choice:\040""", selectedRow.get("NAME"), selectedRow.get("QCHCARDID"));

        int input = 0;
        try {
            input = scanner.nextInt();
            scanner.nextLine();
        } catch (InputMismatchException e) {
            System.out.println("Invalid input: enter integer (1-5)");
            actOnAppointment();
        }

        switch (input) {
            case 1:
                reviewNotes();
                actOnAppointment();
            case 2:
                reviewTests();
                actOnAppointment();
            case 3:
                addNote();
                actOnAppointment();
            case 4:
                prescribeTest();
                actOnAppointment();
            case 5:
                selectAppointment();
            default:
                System.out.println("Invalid selection: valid selections: 1-5");
                actOnAppointment();
        }
    }

    /**
     * Show the notes associated to a pregnancy.
     */
    private static void reviewNotes() {
        try {
            String querySQL = """
                    SELECT TIMESTAMP, DESCRIPTION
                    FROM NOTES
                             JOIN APPOINTMENTS A ON A.APPTID = NOTES.APPTID
                             JOIN PREGNANCIES P ON A.PREGNUM = P.PREGNUM
                        AND A.COUPLEID = P.COUPLEID
                    WHERE A.PREGNUM = %d
                      AND A.COUPLEID = %d
                    ORDER BY TIMESTAMP DESC;
                    """.formatted((int) selectedRow.get("PREGNUM"), (int) selectedRow.get("COUPLEID"));

            java.sql.ResultSet rs = statement.executeQuery(querySQL);

            if (!rs.next()) {
                System.out.println("No notes associated to this pregnancy");
            } else {
                do {
                    System.out.println(
                            rs.getString("TIMESTAMP")
                                    + "\t"
                                    + rs.getString("DESCRIPTION"));
                } while (rs.next());
            }
        } catch (SQLException e) {
            sqlCode = e.getErrorCode();
            sqlState = e.getSQLState();

            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
        }
    }

    /**
     * Show the tests performed the mother associated to the selected pregnancy.
     */
    private static void reviewTests() {
        try {
            String querySQL = """
                    SELECT DATEPRESCRIBED,
                           '[' || TYPE || ']'   AS TYPE,
                           CASE
                               WHEN RESULTS = ''
                                   OR RESULTS IS NULL THEN 'PENDING'
                               ELSE RESULTS END AS RESULTS
                    FROM TESTS
                             JOIN PREGNANCIES P ON TESTS.PREGNUM = P.PREGNUM AND TESTS.COUPLEID = P.COUPLEID
                    WHERE QCHCARDID = '%s'
                      AND P.PREGNUM = %d
                      AND P.COUPLEID = %d
                    ORDER BY DATEPRESCRIBED DESC;
                    """.formatted(selectedRow.get("QCHCARDID"), (int) selectedRow.get("PREGNUM"), (int) selectedRow.get("COUPLEID"));

            java.sql.ResultSet rs = statement.executeQuery(querySQL);

            if (!rs.next()) {
                System.out.println("No tests on the mother associated to this pregnancy");
            } else {
                do {
                    System.out.printf(
                            "%s %s %s%n", rs.getString("DATEPRESCRIBED")
                            , rs.getString("TYPE")
                            , rs.getString("RESULTS"));
                } while (rs.next());
            }
        } catch (SQLException e) {
            sqlCode = e.getErrorCode();
            sqlState = e.getSQLState();

            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
        }
    }

    /**
     * Adds a note with current timestamp with midwife observation.
     */
    private static void addNote() {
        System.out.print("Please type your observation: ");
        String observation = scanner.nextLine();

        try {
            // The note primary keys are not autogenerated (following prof's advice).
            // This is a quick and dirty way of finding out the next available key.
            String querySQL = """
                    SELECT NOTEID
                    FROM NOTES
                    ORDER BY NOTEID DESC;
                    """;
            java.sql.ResultSet rs = statement.executeQuery(querySQL);
            rs.next();
            int pkey = rs.getInt("NOTEID") + 1;
            Timestamp timestamp = new Timestamp(System.currentTimeMillis());


            String insertSQL = """
                    INSERT INTO NOTES
                    VALUES (%d, '%s', '%s', %d);
                    """.formatted(pkey, timestamp, observation, (int) selectedRow.get("APPTID"));
            statement.executeUpdate(insertSQL);
        } catch (SQLException e) {
            sqlCode = e.getErrorCode();
            sqlState = e.getSQLState();

            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
        }
    }

    /**
     * Allows the midwife to prescribe a test for the selected pregnancy.
     * We assume that the test is written for the mother and that the
     * prescription date and date samples are taken is today.
     */
    private static void prescribeTest() {
        System.out.print("Please enter the type of test: ");
        String type = scanner.nextLine();

        try {
            // The test primary keys are not autogenerated (following prof's advice).
            // This is a quick and dirty way of finding out the next available key.
            String querySQL = """
                    SELECT TESTID
                    FROM TESTS
                    ORDER BY TESTID DESC;
                    """;
            java.sql.ResultSet rs = statement.executeQuery(querySQL);
            rs.next();
            int pkey = rs.getInt("TESTID") + 1;

            java.sql.Date currDate = new java.sql.Date(System.currentTimeMillis());


            String insertSQL = """
                    INSERT INTO Tests (TESTID, TYPE, DATEPRESCRIBED, DATESAMPLETAKEN, TECHID, PRACID, PREGNUM, COUPLEID, QCHCARDID)
                    VALUES (%d, '%s', '%s', '%s', %d, %d, %d, %d, '%s');
                    """.formatted(pkey, type, currDate, currDate, 8500, pracId, // a test needs a technician, we're just hardcoding a tech.
                    (int) selectedRow.get("PREGNUM"), (int) selectedRow.get("COUPLEID"), selectedRow.get("QCHCARDID"));
            statement.executeUpdate(insertSQL);
        } catch (SQLException e) {
            sqlCode = e.getErrorCode();
            sqlState = e.getSQLState();

            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println(e);
        }
    }

    /**
     * Close DB connection and statement and exit application.
     *
     * @throws SQLException
     */
    private static void terminateBabbyApp(int status) throws SQLException {
        System.out.println("\nThanks for using Go Babby Application");
        statement.close();
        con.close();
        System.exit(status);
    }

    /**
     * Convert the ResultSet to a List of Maps.
     * https://gist.github.com/cworks/4175942
     *
     * @param rs
     * @return List of Maps where each Map represents a row with columnNames and columValues.
     * @throws SQLException
     */
    private static List<Map<String, Object>> rsToList(ResultSet rs) throws SQLException {
        ResultSetMetaData md = rs.getMetaData();
        int columns = md.getColumnCount();
        List<Map<String, Object>> rows = new ArrayList<>();

        while (rs.next()) {
            Map<String, Object> row = new HashMap<>(columns);
            for (int i = 1; i <= columns; ++i) {
                row.put(md.getColumnName(i), rs.getObject(i));
            }
            rows.add(row);
        }
        return rows;
    }
}