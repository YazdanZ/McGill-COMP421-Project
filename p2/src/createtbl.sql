-- Include your create table DDL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

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
    finalEstDueDate        DATE,             -- determined at a later stage
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
        CHECK ( gender IN ('M', 'F') ), -- determined through tests (M/F binary check)
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