CREATE TABLE Patient (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    age INT,
    location VARCHAR(255)
);

CREATE TABLE Pregnancy (
    pregnancy_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT,
    start_date DATE,
    due_date DATE,
    outcome VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

CREATE TABLE HealthFacility (
    facility_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    location VARCHAR(255),
    capacity INT
);

CREATE TABLE HealthWorker (
    worker_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    specialization VARCHAR(100),
    facility_id INT,
    FOREIGN KEY (facility_id) REFERENCES HealthFacility(facility_id)
);

CREATE TABLE PregnancyHealthWorker (
    pregnancy_id INT,
    worker_id INT,
    PRIMARY KEY (pregnancy_id, worker_id),
    FOREIGN KEY (pregnancy_id) REFERENCES Pregnancy(pregnancy_id),
    FOREIGN KEY (worker_id) REFERENCES HealthWorker(worker_id)
);

SELECT p.name, p.age, p.location, pr.outcome
FROM Patient p
JOIN Pregnancy pr ON p.patient_id = pr.patient_id
WHERE pr.outcome = 'Complicated';

SELECT hf.name, COUNT(pr.pregnancy_id) AS total_pregnancies, COUNT(CASE WHEN pr.outcome = 'Complicated' THEN 1 END) AS complicated_pregnancies
FROM HealthFacility hf
JOIN Pregnancy pr ON hf.facility_id = pr.facility_id
GROUP BY hf.facility_id
ORDER BY complicated_pregnancies DESC;

SELECT hw.name, hw.specialization, COUNT(pr.pregnancy_id) AS complicated_cases
FROM HealthWorker hw
JOIN PregnancyHealthWorker phw ON hw.worker_id = phw.worker_id
JOIN Pregnancy pr ON phw.pregnancy_id = pr.pregnancy_id
WHERE pr.outcome = 'Complicated'
GROUP BY hw.worker_id
ORDER BY complicated_cases DESC;

SELECT COUNT(CASE WHEN pr.outcome = 'Complicated' THEN 1 END) / COUNT(pr.pregnancy_id) AS maternal_mortality_rate
FROM Pregnancy pr;

SELECT YEAR(pr.start_date) AS year, COUNT(CASE WHEN pr.outcome = 'Complicated' THEN 1 END) AS complicated_pregnancies
FROM Pregnancy pr
GROUP BY YEAR(pr.start_date)
ORDER BY YEAR(pr.start_date);

SELECT p.location, COUNT(CASE WHEN pr.outcome = 'Complicated' THEN 1 END) AS complicated_pregnancies
FROM Patient p
JOIN Pregnancy pr ON p.patient_id = pr.patient_id
GROUP BY p.location
ORDER BY complicated_pregnancies DESC;