-- Include your INSERT SQL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
-- CONNECT TO cs421;

-- Remember to put the INSERT statements for the tables with foreign key references
--    ONLY AFTER the parent tables!

INSERT INTO HealthcareInstitutions (hcId, phoneNum, name, email, address)
VALUES (1, '514 934-1934', 'McGill University Health Center', 'patients.comm@muhc.mcgill.ca',
        '1001 Decarie Blvd, Montreal, Quebec H4A 3J1'),
       (2, '514-340-8222', 'Jewish General Hospital', 'library.jgh@mail.mcgill.ca',
        '3755 Côte-Sainte-Catherine  Road Montréal, Québec, Canada H3T 1E2'),
       (3, '514 890-8000', 'Centre hospitalier de l''Université de Montréal', 'email@chum.qc.ca',
        '1000, rue Saint-Denis Montréal (Québec)  H2X 0C1'),
       (4, '(514) 345-3511', 'St. Mary''s Hospital Center', 'contact@smhc.qc.ca',
        '3830 Lacombe Avenue, Montreal, Quebec H3T 1M5'),
       (5, '514 323-2273', 'Lac-Saint-Louis', 'hello@stlouishospital.qc.ca',
        '180, avenue Cartier Pointe-Claire, Québec H9S 4S1'),
       (6, '514-731-8531', 'CLSC de Côte-des-Neiges', 'contact@ciussswestcentral.ca',
        '5700 Côte-des-Neiges Road Montreal, Quebec H3T 2A8'),
       (7, '514 413-8777', ' Hôpital Notre-Dame', 'contact@ciusss-centresudmtl.gouv.qc.ca',
        '1560, rue Sherbrooke Est Montréal QC H2L 4M1'),
       (8, '416 340 4800', 'Toronto General Hospital', 'contact@uhn.ca', '200 Elizabeth St, Toronto, ON M5G 2C4'),
       (9, '416-596-4200', 'Mount Sinai Hospital', 'patientrelations@sinaihealth.ca',
        ' Joseph & Wolf Lebovic Health Complex 600 University Avenue Toronto, ON M5G 1X5'),
       (10, '416-461-8272', 'Michael Garron Hospital', 'email@tehn.ca', '825 Coxwell Avenue Toronto ON M4C 3E7');

INSERT INTO CommunityClinics
VALUES (1),
       (2),
       (7),
       (9),
       (10);

INSERT INTO BirthingCenters
VALUES (3),
       (4),
       (5),
       (6),
       (8);

INSERT INTO Midwives
VALUES (1001, 'Marion Girard', 'mgirard@muhc.mcgill.ca', '514 556-6666', 1),
       (1002, 'Baal Hammon Maly', 'hammonm@stlouishospital.qc.ca', '675 662-9861', 5),
       (1003, 'Najla Vazquez', 'nvazquez@tehn.ca', '221 121-7812', 10),
       (1004, 'Demeter Kralj', 'demeterk@tehn.ca', '234 233-2234', 10),
       (1005, 'Rauf Pasternack', 'raufpasternack@smhc.qc.ca', '997 764-1123', 4),
       (1006, 'Adad Case', 'addad.case@chum.qc.ca', '514 667 0907', 3),
       (1007, 'Nisha Harper', 'nisha.harper@muhc.mcgill.ca', '514 898-6129', 5),
       (1008, 'Taio Valentine', 'tvalentine@ciussswestcentral.ca', '514 121-7412', 6),
       (1009, 'Dahlia Thomson', 'd.thomson2@smhc.qc.ca', '642 122 7197', 4),
       (1010, 'Sameera Schmitt', 'shmitt@sinaihealth.ca', '+1 514 223 2311', 9);


INSERT INTO Fathers
VALUES (2011, '514 664 2223', 'Dario Potter', NULL, '1130 Pitt St Cornwall', NULL, '1990-09-18', 'Engineer', 'A+'),
       (2012, '516 223 2186', 'Columbus Lucero', 'clucero@protonmail.com', '3012 St. John Street Big River S4P 3Y2 SK',
        'COLC23423435', '1995-02-12', 'UNEMPLOYED',
        NULL),
       (2013, '(792) 861-3005', 'Hossein Walls', 'pm@hwalls.me', NULL, NULL, '1993-03-07', 'Plumber', 'O+'),
       (2014, '1-432-282-8220', 'Felipe Herman', 'fherman@tutanota.com', 'Ap #163-304 Dictum Road', 'FEHE13450987',
        '2000-01-02', 'Teacher', NULL),
       (2015, '1-432-282-8220', 'Colton Thompson', 'colthomp@pm.me', NULL, NULL, '1989-12-11', 'Bank manager', 'AB-');


INSERT INTO Mothers
VALUES ('JAGA23412231', '613-555-0184', 'Janette Gamble', 'jgamble@email.com', '36 Beechwood Avenue Garner, NC 27529',
        '1992-12-11', 'Tiktoker', 'A-'),
       ('CASL23451234', '613-555-0108', 'Corina Solis', 'corina.solis@mail.mcgill.ca',
        '7607 Temple Dr. Lady Lake, FL 32159', '1994-04-05', 'Housewife', NULL),
       ('BOCH07562649', '(403)557-2590', 'Bobbi Cherry', 'bobbi.c@icloud.com', '451 Airport Drive Nanuet, NY 10954',
        '1992-12-02', 'Housewife', 'O-'),
       ('MAME17823471', '(778)789-5830', 'Maryellen Mercer', 'mmercer@tuta.io', '55 Lookout St. Port Richey, FL 34668',
        '1989-03-12', 'Software Developer', NULL),
       ('JULE09156234', '(514)723-9434', 'Judith Leon', 'jud_leon@yahoo.ca',
        '340 E. Henry Smith Street Akron, OH 44312', '2002-01-02', 'Student', 'B+'),
       ('KASA12232567', '(418)561-2943', 'Katie Salinas', 'katie.salinas@noreply.github.com',
        '252 Monroe St.Monroeville, PA 15146', '2001-02-02', 'HR manager', 'B+'),
       ('TIBR08957842', '613-555-0114', 'Tiffany Brennan', 'tiffany6712@icloud.com',
        '21 Courtland St. Sewell, NJ 08080', '2004-04-21', 'Nurse', 'B-');


INSERT INTO Couples
VALUES (4000, TRUE, TRUE, TRUE, 'JAGA23412231', 2011),
       (4001, TRUE, TRUE, TRUE, 'JAGA23412231', 2015),
       (4002, TRUE, TRUE, TRUE, 'CASL23451234', NULL),
       (4003, TRUE, TRUE, TRUE, 'JAGA23412231', NULL),
       (4004, TRUE, TRUE, TRUE, 'BOCH07562649', 2015),
       (4005, TRUE, TRUE, TRUE, 'JULE09156234', 2012),
       (4006, TRUE, TRUE, FALSE, 'KASA12232567', 2014),
       (4007, TRUE, TRUE, TRUE, 'TIBR08957842', 2012),
       (4008, TRUE, FALSE, FALSE, 'JULE09156234', 2013),
       (4009, TRUE, TRUE, TRUE, 'KASA12232567', NULL);

INSERT INTO InformationSessions
VALUES (10000, 'English', '2022-02-20', '10:00:00', 1001),
       (10001, 'English', '2023-09-20', '10:00:00', 1001),
       (10002, 'Persian', '2022-10-28', '13:30:00', 1003),
       (10003, 'French', '2021-11-07', '15:45:00', 1005),
       (10004, 'Spanish', '2020-01-26', '09:00:00', 1008),
       (10005, 'Persian', '2023-02-15', '15:30:00', 1003),
       (10006, 'Pashto', '2021-12-20', '14:00:00', 1006),
       (10007, 'Urdu', '2023-04-02', '08:10:00', 1010);

INSERT INTO Invitations
VALUES (10000, 4005, TRUE, TRUE),
       (10000, 4008, TRUE, TRUE),
       (10000, 4007, FALSE, FALSE),
       (10002, 4008, TRUE, TRUE),
       (10002, 4006, TRUE, TRUE),
       (10006, 4003, FALSE, TRUE),
       (10006, 4002, TRUE, TRUE),
       (10007, 4000, TRUE, TRUE),
       (10007, 4004, TRUE, TRUE),
       (10004, 4001, TRUE, TRUE),
       (10005, 4009, TRUE, TRUE),
       (10001, 4009, FALSE, FALSE);

INSERT INTO Pregnancies
VALUES (4000, 1, '2022-02-06', '2022-02-14', NULL, '2021-01-05', TRUE, 1001, 1002),
       (4001, 1, '2022-02-06', '2022-02-14', NULL, NULL, FALSE, 1002, 1001),
       (4003, 3, '2022-06-09', '2022-06-20', '2022-06-19', '2021-09-01', TRUE, 1003, 1002),
       (4005, 2, '2023-01-01', '2023-02-01', '2023-02-02', '2022-09-20', FALSE, 1009, 1007),
       (4009, 2, '2022-03-01', '2022-03-09', '2023-02-03', '2022-09-01', TRUE, 1008, 1006),
       (4004, 1, '2022-03-02', '2022-03-10', NULL, NULL, NULL, 1004, 1005),
       (4000, 2, '2023-03-06', '2023-04-14', '2023-03-01', '2022-11-02', TRUE, 1006, 1010),
       (4008, 1, '2024-02-04', '2024-03-04', '2024-03-02', '2023-04-05', FALSE, 1004, 1002);

INSERT INTO Appointments
VALUES (2601, '2022-01-03', '16:00:00', 1, 4000, 1001),
       (2602, '2022-02-04', '09:00:00', 1, 4000, 1001),
       (2603, '2022-02-05', '09:00:00', 1, 4000, 1002),
       (2604, '2022-04-28', '17:00:00', 3, 4003, 1003),
       (2605, '2022-04-29', '07:45:00', 2, 4005, 1009),
       (2606, '2022-05-29', '07:45:00', 2, 4005, 1009),
       (2607, '2022-06-29', '07:45:00', 1, 4008, 1004),
       (2608, '2022-05-29', '08:45:00', 1, 4004, 1004),
       (2609, '2022-09-29', '09:45:00', 2, 4009, 1008),
       (2610, '2022-12-29', '10:35:00', 2, 4005, 1007);

INSERT INTO Notes
VALUES (2701, '2022-01-03-16.30.20', 'All good!', 2601),
       (2702, '2022-01-03-16.25.30', 'Mother is healthy', 2601),
       (2703, '2022-02-04-09:45:00', 'Baby is gonna die', 2602),
       (2704, '2022-04-28-17:50:00', 'Mother has pain', 2604),
       (2705, '2022-04-29-08:12:54', 'Increase med dosage', 2605),
       (2706, '2022-05-29-07:50:12', 'No comment', 2606),
       (2707, '2022-06-29-08:34:02', 'Baby is healthy', 2607),
       (2708, '2022-05-29-08:45:02', 'Its a twin', 2608),
       (2709, '2022-12-29-10:56:23', 'Baby has brain damage', 2610),
       (2710, '2022-12-29-10:50:19', 'I hate my job', 2610),
       (2711, '2022-12-29-10:50:22', 'Ah shit, here we go again.', 2610);


INSERT INTO Babies
VALUES (6901, 'Shitling', 'M', '10:02:02', '2022-06-19', 'A+', 3, 4003),
       (6902, 'lil nugget', 'F', '00:03:13', '2022-06-19', 'A+', 3, 4003),
       (6903, 'X AE A-Xii', 'M', '01:52:59', '2023-02-02', NULL, 2, 4005),
       (6004, 'Baby shark dududu', 'M', '09:34:23', '2024-03-02', 'O+', 1, 4008),
       (6905, 'No name lol', 'F', '19:22:34', '2022-03-10', NULL, 1, 4004);

INSERT INTO Technicians
VALUES (8500, 'Cnut Zulfikar', '514 667 7213'),
       (8501, 'Sháńdíín Theano', '672 121 9236'),
       (8502, 'Aeson Urban', '912 223 2342'),
       (8503, 'Rian Felicity', '514 152 1231'),
       (8504, 'Zdenko Jim', '612 435 1311');

INSERT INTO Tests
VALUES (1001, 'blood iron', '2022-03-23', '2022-03-24', 'All good', '2022-03-24', 'McGill labs', 8500, 1004, 1, 4004,
        6905, NULL),
       (1002, 'monthly check', '2022-03-23', '2022-04-24', 'Bad news...', '2022-04-25', 'UdeM labs', 8500, 1004, 1,
        4004, NULL, 'BOCH07562649'),
       (1003, 'blood iron', '2021-07-05', '2021-07-06', 'Too much iron lol', '2021-07-07', 'General hospital labs',
        8501, 1003, 3, 4003, 6901, NULL),
       (1004, 'blood iron', '2021-06-05', '2021-07-06', 'Too much iron lol', '2021-08-07', 'General hospital labs',
        8502, 1003, 3, 4003, NULL, 'JAGA23412231'),
       (1005, 'monthly check', '2023-03-02', '2023-04-01', 'Everything good', '2023-04-05', 'Jewish hospital labs',
        8503, 1008, 3, 4003, NULL, 'JAGA23412231');

INSERT INTO BirthLocations
VALUES (3, 3, 4003),
       (4, 2, 4009),
       (5, 2, 4000),
       (5, 1, 4000),
       (8, 3, 4003);