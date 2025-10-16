CREATE DATABASE insurance_db;
USE insurance_db;
CREATE TABLE PERSON (
    driver_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(255)
);

CREATE TABLE CAR (
    reg_num VARCHAR(50) PRIMARY KEY,
    model VARCHAR(100),
    year INT
);

CREATE TABLE ACCIDENT (
    report_num INT PRIMARY KEY,
    accident_date DATE,
    location VARCHAR(255)
);

CREATE TABLE OWNS (
    driver_id VARCHAR(50),
    reg_num VARCHAR(50),
    PRIMARY KEY(driver_id, reg_num),
    FOREIGN KEY (driver_id) REFERENCES PERSON(driver_id),
    FOREIGN KEY (reg_num) REFERENCES CAR(reg_num)
);

CREATE TABLE PARTICIPATED (
    driver_id VARCHAR(50),
    reg_num VARCHAR(50),
    report_num INT,
    damage_amount INT,
    PRIMARY KEY(driver_id, reg_num, report_num),
    FOREIGN KEY (driver_id) REFERENCES PERSON(driver_id),
    FOREIGN KEY (reg_num) REFERENCES CAR(reg_num),
    FOREIGN KEY (report_num) REFERENCES ACCIDENT(report_num)
);

INSERT INTO PERSON VALUES
('D1', 'Ankit', '123 Elm St'),
('D2', 'Rahul', '456 Oak St'),
('D3', 'Rishu', '789 Pine St'),
('D4', 'Sumit', '101 Maple St'),
('D5', 'Amit', '202 Birch St');

INSERT INTO CAR VALUES
('KA053408', 'Toyota Camry', 2019),
('KA053409', 'Honda Accord', 2020),
('KA053410', 'Ford Mustang', 2018),
('KA053411', 'Tesla Model 3', 2021),
('KA053412', 'Chevrolet Malibu', 2017);


INSERT INTO ACCIDENT VALUES
(10, '2023-01-15', 'Main St and 1st Ave'),
(11, '2023-02-20', 'Elm St and 2nd Ave'),
(12, '2023-03-25', 'Oak St and 3rd Ave'),
(13, '2023-04-30', 'Pine St and 4th Ave'),
(14, '2023-05-10', 'Maple St and 5th Ave');

INSERT INTO OWNS VALUES
('D1', 'KA053408'),
('D2', 'KA053409'),
('D3', 'KA053410'),
('D4', 'KA053411'),
('D5', 'KA053412');

INSERT INTO PARTICIPATED VALUES
('D1', 'KA053408', 10, 15000),
('D2', 'KA053409', 11, 30000),
('D3', 'KA053410', 12, 5000),
('D4', 'KA053411', 13, 20000),
('D5', 'KA053412', 14, 40000);

SELECT accident_date, location FROM ACCIDENT;

UPDATE PARTICIPATED
SET damage_amount = 25000
WHERE reg_num = 'KA053408' AND report_num = 12;

INSERT INTO ACCIDENT (report_num, accident_date, location)
VALUES (15, '2023-06-15', 'New Location St and 6th Ave');

SELECT driver_id
FROM PARTICIPATED
WHERE damage_amount >= 25000;