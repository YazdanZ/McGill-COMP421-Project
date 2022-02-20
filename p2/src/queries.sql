-- Include your create table DDL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
-- TODO: Uncomment this line before project submission
-- CONNECT TO cs421;

-- Remember to put the create table ddls for the tables with foreign key references
--    ONLY AFTER the parent tables has already been created.


CREATE TABLE HealthcareInstitutions
(
    hcId     INTEGER      NOT NULL,
    phoneNum VARCHAR(22)  NOT NULL,      -- 10 digits for CA and US phones
    -- varchar since it can have '+', leading zeros, '#' and be sip.
    -- 22 supports most numbers (including extensions)
    name     VARCHAR(50)  NOT NULL,
    email    VARCHAR(319) NOT NULL UNIQUE
        -- 64 characters for the username
        -- 1 character for '@'
        -- 254 characters for the domain name
        CHECK (email LIKE '%_@__%.__%'), -- simple check
    -- application needs to more thoroughly validate email
    address  VARCHAR(500) NOT NULL,      -- 500 char limit is reasonable
    website  VARCHAR(500),               -- optional
    PRIMARY KEY (hcId)
);

CREATE TABLE CommunityClinics
(
    hcId INTEGER NOT NULL,
    PRIMARY KEY (hcId),
    FOREIGN KEY (hcId)
        REFERENCES HealthcareInstitutions
);

CREATE TABLE BirthingCenters
(
    hcId INTEGER NOT NULL,
    PRIMARY KEY (hcId),
    FOREIGN KEY (hcId)
        REFERENCES HealthcareInstitutions
);

CREATE TABLE Midwives
(
    pracId   INTEGER      NOT NULL,
    name     VARCHAR(30)  NOT NULL,
    email    VARCHAR(319) NOT NULL UNIQUE
        CHECK (email LIKE '%_@__%.__%'), -- simple check
    -- application needs to more thoroughly validate email
    phoneNum VARCHAR(22)  NOT NULL,
    hcId     INTEGER      NOT NULL,
    PRIMARY KEY (pracId),
    FOREIGN KEY (hcId)
        REFERENCES HealthcareInstitutions
);

CREATE TABLE Fathers
(
    fatherId    INTEGER     NOT NULL,
    phoneNum    VARCHAR(22) NOT NULL,
    name        VARCHAR(30) NOT NULL,
    email       VARCHAR(319)             -- optional for registering
        -- cannot enforce uniqueness due to not being NOT NULL
        CHECK (email LIKE '%_@__%.__%'), -- simple check
    -- application needs to more thoroughly validate email
    address     VARCHAR(500),            -- optional for registering
    QChcardid   CHAR(12),                -- optional for registering
    -- cannot enforce uniqueness due to not being NOT NULL
    dateOfBirth DATE        NOT NULL,
    profession  VARCHAR(30) NOT NULL,
    bloodType   VARCHAR(3)
        CHECK
            (
                bloodType IN
                ('A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-')
            ),                           -- determined at a later stage
    PRIMARY KEY (fatherId)
);

CREATE TABLE Mothers
(
    QChcardid   CHAR(12)     NOT NULL,
    phoneNum    VARCHAR(22)  NOT NULL,
    name        VARCHAR(30)  NOT NULL,
    email       VARCHAR(319) NOT NULL UNIQUE
        CHECK (email LIKE '%_@__%.__%'), -- simple check
    -- application needs to more thoroughly validate email
    address     VARCHAR(500) NOT NULL,
    dateOfBirth DATE         NOT NULL,
    profession  VARCHAR(30)  NOT NULL,
    bloodType   VARCHAR(3)
        CHECK
            (
                bloodType IN
                ('A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-')
            ),                           -- determined at a later stage
    PRIMARY KEY (QChcardid)
);

CREATE TABLE Couples
(
    coupleId   INTEGER  NOT NULL,
    invited    BOOLEAN  NOT NULL DEFAULT FALSE,
    interested BOOLEAN  NOT NULL DEFAULT FALSE,
    selected   BOOLEAN  NOT NULL DEFAULT FALSE,
    QChcardid  CHAR(12) NOT NULL,
    fatherId   INTEGER, -- a single mother can constitute a couple
    PRIMARY KEY (coupleId),
    FOREIGN KEY (QChcardid)
        REFERENCES Mothers,
    FOREIGN KEY (fatherId)
        REFERENCES Fathers
);

CREATE TABLE InformationSessions
(
    sessId   INTEGER     NOT NULL,
    language VARCHAR(20) NOT NULL,
    date     DATE        NOT NULL,
    time     TIME        NOT NULL,
    pracId   INTEGER     NOT NULL,
    PRIMARY KEY (sessId),
    FOREIGN KEY (pracId)
        REFERENCES Midwives
);

CREATE TABLE Invitations
(
    sessId     INTEGER NOT NULL,
    coupleId   INTEGER NOT NULL,
    attended   BOOLEAN NOT NULL DEFAULT FALSE,
    registered BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (sessId, coupleId),
    FOREIGN KEY (sessId)
        REFERENCES InformationSessions,
    FOREIGN KEY (coupleId)
        REFERENCES Couples
);

CREATE TABLE Pregnancies
(
    coupleId          INTEGER NOT NULL,
    pregNum           INTEGER NOT NULL CHECK ( pregNum > 0 ),
    expBirthTimeframe DATE    NOT NULL, -- will only store YEAR-MONTH, we ignore DAY
    finalEstDueDate   DATE,             -- determined at a later stage
    lastMenstPeriod   DATE,             -- recorded at a later stage
    isHomeBirth       BOOLEAN,          -- decided at a later stage
    primaryMidwife    INTEGER,          -- assigned at a later stage
    backupMidwife     INTEGER,          -- assigned at a later stage
    PRIMARY KEY (pregNum, coupleId),
    FOREIGN KEY (coupleId)
        REFERENCES Couples,
    FOREIGN KEY (primaryMidwife)
        REFERENCES Midwives (pracId),
    FOREIGN KEY (backupMidwife)
        REFERENCES Midwives (pracId),
    CHECK ( primaryMidwife <> backupMidwife )
);

CREATE TABLE Appointments
(
    apptId   INTEGER NOT NULL,
    date     DATE    NOT NULL,
    time     TIME    NOT NULL,
    pregNum  INTEGER NOT NULL,
    coupleId INTEGER NOT NULL,
    pracId   INTEGER NOT NULL,
    PRIMARY KEY (apptId),
    FOREIGN KEY (pregNum, coupleId)
        REFERENCES Pregnancies,
    FOREIGN KEY (pracId)
        REFERENCES Midwives
);

CREATE TABLE Notes
(
    noteId      INTEGER        NOT NULL,
    timestamp   TIMESTAMP      NOT NULL,
    description VARCHAR(10000) NOT NULL, -- 10000 is a reasonable max char length
    apptId      INTEGER        NOT NULL,
    PRIMARY KEY (noteId),
    FOREIGN KEY (apptId)
        REFERENCES Appointments
);

CREATE TABLE Babies
(
    babyId      INTEGER NOT NULL,
    name        VARCHAR(30),                       -- can be determined at a later time
    gender      CHAR(1)
        CHECK ( gender IN ('M', 'F', 'unknown') ), -- determined through tests (M/F binary check)
    timeOfBirth TIME,                              -- recorded after birth
    dateOfBirth DATE,                              -- recorded after birth
    bloodType   VARCHAR(3)
        CHECK
            (
                bloodType IN
                ('A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-')
            ),                                     -- determined at a later stage
    pregNum     INTEGER NOT NULL,
    coupleId    INTEGER NOT NULL,
    PRIMARY KEY (babyId),
    FOREIGN KEY (pregNum, coupleId)
        REFERENCES Pregnancies
);

CREATE TABLE Technicians
(
    techId   INTEGER     NOT NULL,
    name     VARCHAR(30) NOT NULL,
    phoneNum VARCHAR(22) NOT NULL,
    PRIMARY KEY (techId)
);

CREATE TABLE Tests
(
    testId          INTEGER     NOT NULL,
    type            VARCHAR(30) NOT NULL,
    datePrescribed  DATE        NOT NULL,
    dateSampleTaken DATE,                                        -- can be NULL for tests without sample
    results         VARCHAR(10000),                              -- recorded once test is performed (10000 is a reasonable char max lenght)
    dateConducted   DATE,                                        -- recorded once test is conducted
    lab             VARCHAR(30),                                 -- labs are out of scope of this project (we simply record lab name)
    -- We assume that a test can be performed outside a lab (e.g., by a midwife)
    techId          INTEGER     NOT NULL,
    pracId          INTEGER     NOT NULL,
    pregNum         INTEGER     NOT NULL,
    coupleId        INTEGER     NOT NULL,
    babyId          INTEGER,                                     -- can be null (e.g., test performed on mother)
    QChcardid       CHAR(12),                                    -- can be null (e.g., test performed on baby)
    PRIMARY KEY (testId),
    FOREIGN KEY (pregNum, coupleId)
        REFERENCES Pregnancies,
    FOREIGN KEY (techId)
        REFERENCES Technicians,
    FOREIGN KEY (pracId)
        REFERENCES Midwives,
    FOREIGN KEY (babyId)
        REFERENCES Babies,
    FOREIGN KEY (QChcardid)
        REFERENCES Mothers,
    CHECK ( dateConducted >= dateSampleTaken AND dateSampleTaken >= datePrescribed ),
    CHECK ( (babyId IS NULL OR QChcardid IS NULL)
        AND NOT (babyId IS NOT NULL AND QChcardid IS NOT NULL) ) -- test for only mother OR baby
);

CREATE TABLE BirthLocations -- This relation only created when birth is at a Birthing Center
(
    hcId     INTEGER NOT NULL,
    pregNum  INTEGER NOT NULL,
    coupleId INTEGER NOT NULL,
    PRIMARY KEY (hcId, pregNum, coupleId),
    FOREIGN KEY (hcId)
        REFERENCES BirthingCenters,
    FOREIGN KEY (pregNum, coupleId)
        REFERENCES Pregnancies
);

-- Write a SQL query that will list all the appointments for the midwife Marion Girard for the week March
-- 21 - March 25 of this year (2022). The output must be the date and time of the appointment as well
-- as the health care card, name and phone number of the mother. You can assume that there is only one
-- midwife with this particular name.
SELECT date, time, Mothers.QChcardid, Mothers.name, Mothers.phoneNum
FROM Appointments
         JOIN Midwives on Midwives.pracId = Appointments.pracId
         JOIN Couples on Couples.coupleId = Appointments.coupleId
         JOIN Mothers on Mothers.QChcardid = Couples.QChcardid
WHERE Midwives.name = 'Marion Girard'
  AND date BETWEEN '2022-03-21' AND '2022-03-25';

-- Write a SQL query that will list the results of all the blood iron tests that was performed on (Mother)
-- Victoria Gutierrez for her second pregnancy. The output should have lab date and the result (the latter
-- you can assume as a simple VARCHAR field with some text info - keep it a small field so your screen does
-- not get cluttered).
WITH motherid (QChcardid) AS (
    SELECT QChcardid
    FROM Mothers
    WHERE name = 'Victoria Gutierrez'
)
SELECT dateConducted, results
FROM Tests
WHERE type = 'blood iron'
  AND (coupleId, pregNum) IN (
    SELECT coupleId, pregNum
    FROM Pregnancies
    WHERE coupleId = (
        SELECT coupleId
        FROM Couples
        WHERE QChcardid = (SELECT QChcardid FROM motherid)
    )
      AND pregNum = 2
);

-- Write a SQL query that will list the names of each birthing center/community clinic as well as the number
-- of pregnancies that are due for the month of July this year (2022). For this purpose you will count a
-- pregnancy towards a facility if the primary midwife is from that facility (and not based on the final birthing
-- location). You should also use the “final agreed up on” due date if that is present, in order to figure out
-- if the pregnancy will fall into a specific month. Otherwise (if that information is not yet available), use
-- the expected time frame for birth (year-month) that was provided initially.
SELECT HealthcareInstitutions.name, COALESCE(COUNT(primaryMidwife), 0) AS pregCount
FROM (
         SELECT *
         FROM Pregnancies
                  JOIN Midwives ON Pregnancies.primaryMidwife = Midwives.pracId
         WHERE (finalEstDueDate BETWEEN '2022-07-01' AND '2022-07-31')
            OR (finalEstDueDate IS NULL AND YEAR(expBirthTimeframe) = 2022 AND MONTH(expBirthTimeframe) = 7)
     ) pregnancies
         RIGHT OUTER JOIN HealthcareInstitutions
                          ON pregnancies.hcId = HealthcareInstitutions.hcId
GROUP BY HealthcareInstitutions.name;

-- Write a SQL query that will list the health care card, name and phone number of the mothers who is
-- currently pregnant and have not yet given birth and is under the care of a midwife employed by Lac-
-- Saint-Louis. You can assume that there is only one facility by that name.
WITH stLouisMidwives (pracId) AS (
    SELECT pracId
    FROM Midwives
    WHERE hcId = (
        SELECT hcid
        FROM HealthcareInstitutions
        WHERE name = 'Lac-Saint-Louis'
    )
)
SELECT *
FROM Pregnancies
         JOIN Couples ON Pregnancies.coupleId = Couples.coupleId
         JOIN Mothers on Couples.QChcardid = Mothers.QChcardid
WHERE primaryMidwife IN (SELECT * FROM stLouisMidwives)
   OR backupMidwife IN (SELECT * FROM stLouisMidwives);

SELECT pregNum, coupleId
FROM Babies
WHERE dateOfBirth IS NOT NULL;
SELECT current date
FROM sysibm.sysdummy1;
-- get today's date
-- undone (ask for clarifications)

-- Write a SQL query that will list the health care card, name of mothers who have had more than one baby
-- in a single pregnancy. List them only once even if they had multiple pregnancies where they had more
-- than one baby. Count the babies whether they are born or not (yet).
SELECT QChcardid, name
FROM Mothers
WHERE QChcardid IN (
    SELECT QChcardid
    FROM Couples
    WHERE coupleId IN (
        SELECT coupleId
        FROM Babies
        GROUP BY (coupleId, pregNum)
        HAVING COUNT(*) > 1
    )
);

-- Create a view midwifeinfo that shows the practitioner id, name, phone and email of all the
-- midwives, the name of the clinic / birthing center that employs them, and the address of the facility. Include
-- the responses to this question under the section “Midwife Information” in your project2.pdf.
CREATE VIEW midwifeinfo (pracId, name, phoneNum, email, InstituteName, InstituteAddress) AS
SELECT pracId, m.name, m.phoneNum, m.email, hInst.name, hInst.address
FROM Midwives m
         JOIN HealthcareInstitutions hInst on m.hcId = hInst.hcId;

SELECT *
FROM midwifeinfo
LIMIT 5;

INSERT INTO midwifeinfo
VALUES (100000, 'Ashley Wayne', '514 565-2232', 'ashley@gmail.com', 'Lac-Saint-Louis', '180, avenue Cartier Pointe-Claire, Québec H9S 4S1');

ALTER TABLE Tests ADD CONSTRAINT dateconstraint CHECK (dateConducted >= datePrescribed);
