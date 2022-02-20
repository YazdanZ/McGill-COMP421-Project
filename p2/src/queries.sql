-- Write a SQL query that will list all the appointments for the midwife Marion Girard for the week March
-- 21 - March 25 of this year (2022). The output must be the date and time of the appointment as well
-- as the health care card, name and phone number of the mother. You can assume that there is only one
-- midwife with this particular name.
SELECT date, time, Mothers.QChcardid, Mothers.name, Mothers.phoneNum
FROM Appointments
         JOIN Midwives ON Midwives.pracId = Appointments.pracId
         JOIN Couples ON Couples.coupleId = Appointments.coupleId
         JOIN Mothers ON Mothers.QChcardid = Couples.QChcardid
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
)
  AND QChcardid = (SELECT QChcardid FROM motherid);

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
SELECT DISTINCT Mothers.QChcardid, name, phoneNum
FROM Pregnancies
         JOIN Couples ON Pregnancies.coupleId = Couples.coupleId
         JOIN Mothers on Couples.QChcardid = Mothers.QChcardid
WHERE primaryMidwife IN (SELECT * FROM stLouisMidwives)
   OR backupMidwife IN (SELECT * FROM stLouisMidwives)
    AND (Pregnancies.coupleId, Pregnancies.pregNum) NOT IN (
        SELECT coupleId, pregNum
        FROM Babies
        WHERE dateOfBirth IS NOT NULL
    );

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

-- Screenshot of a SQL query on the view that limits the previous output to only the midwives working at
-- the facility whose name is Lac-Saint-Louis. You can assume there is only one facility with that name.
-- Truncate the output to just 5 records.
SELECT *
FROM midwifeinfo
LIMIT 5;

-- Now try inserting a record into the view (practitioner id, name, phone, etc., the attributes that are
-- mentioned in the view’s output) that has valid domain values for these attributes (e.g. a new midwife,
-- but an existing facility). Observe what happens. Take a screenshot and turn in that along with the
-- explanation of why this happened.
INSERT INTO midwifeinfo
VALUES (100000, 'Ashley Wayne', '514 565-2232', 'ashley@gmail.com', 'Lac-Saint-Louis',
        '180, avenue Cartier Pointe-Claire, Québec H9S 4S1');

-- Add a CHECK constraint to your respective table to ensure that the lab date associated with a test
-- cannot be a date before the date the test was prescribed.
ALTER TABLE Tests
    ADD CONSTRAINT dateconstraint CHECK (dateConducted >= datePrescribed);
