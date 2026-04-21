USE SmartCityDB;

-- ======================
-- CLEAN OLD DATA
-- ======================
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS ComplaintUpdate;
DROP TABLE IF EXISTS Complaint;
DROP TABLE IF EXISTS Officer;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Citizen;
DROP TABLE IF EXISTS SLA;

SET FOREIGN_KEY_CHECKS = 1;

-- ======================
-- TABLE CREATION
-- ======================

CREATE TABLE Citizen (
    CitizenID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Contact VARCHAR(15)
);

CREATE TABLE Category (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100)
);

CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100)
);

CREATE TABLE Officer (
    OfficerID INT PRIMARY KEY AUTO_INCREMENT,
    OfficerName VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE SLA (
    SLAID INT PRIMARY KEY AUTO_INCREMENT,
    SLA_Days INT
);

CREATE TABLE Complaint (
    ComplaintID INT PRIMARY KEY AUTO_INCREMENT,
    CitizenID INT,
    CategoryID INT,
    DepartmentID INT,
    ComplaintDescription TEXT,
    SLADedline DATE,
    Status ENUM('In Progress', 'Resolved') DEFAULT 'In Progress',
    OfficerID INT,
    FOREIGN KEY (CitizenID) REFERENCES Citizen(CitizenID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (OfficerID) REFERENCES Officer(OfficerID)
);

CREATE TABLE ComplaintUpdate (
    UpdateID INT PRIMARY KEY AUTO_INCREMENT,
    ComplaintID INT,
    UpdateTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    Remarks TEXT,
    UpdatedBy VARCHAR(100),
    FOREIGN KEY (ComplaintID) REFERENCES Complaint(ComplaintID)
);

-- ======================
-- INSERT DATA (15+ RECORDS)
-- ======================

-- Citizens
INSERT INTO Citizen (Name, Contact) VALUES
('Veeraj Ghalyan','9876543210'),
('Aman Sharma','9123456780'),
('Riya Singh','9012345678'),
('Karan Mehta','9988776655'),
('Sneha Verma','9871234567');

-- Category
INSERT INTO Category (CategoryName) VALUES
('Water Issue'),
('Electricity'),
('Road Damage');

-- Department
INSERT INTO Department (DepartmentName) VALUES
('Water Dept'),
('Electric Dept'),
('Road Dept');

-- Officers
INSERT INTO Officer (OfficerName, DepartmentID) VALUES
('Raj Sharma',1),
('Amit Verma',2),
('Suresh Kumar',3);

-- SLA
INSERT INTO SLA (SLA_Days) VALUES (3),(5),(7);

-- ======================
-- TRIGGER (AUTO SLA)
-- ======================
DELIMITER //

CREATE TRIGGER set_sla_deadline
BEFORE INSERT ON Complaint
FOR EACH ROW
BEGIN
    DECLARE days INT;
    SELECT SLA_Days INTO days FROM SLA LIMIT 1;
    SET NEW.SLADedline = CURDATE() + INTERVAL days DAY;
END;
//

DELIMITER ;

-- ======================
-- STORED PROCEDURE
-- ======================
DROP PROCEDURE IF EXISTS RegisterComplaint;
DELIMITER //

CREATE PROCEDURE RegisterComplaint(
    IN cID INT,
    IN catID INT,
    IN deptID INT,
    IN descp TEXT,
    IN offID INT
)
BEGIN
    INSERT INTO Complaint (CitizenID, CategoryID, DepartmentID, ComplaintDescription, OfficerID)
    VALUES (cID, catID, deptID, descp, offID);
END;
//

DELIMITER ;

-- ======================
-- INSERT 15 COMPLAINTS
-- ======================

CALL RegisterComplaint(1,1,1,'Water leakage near park',1);
CALL RegisterComplaint(2,2,2,'Power cut in sector 5',2);
CALL RegisterComplaint(3,3,3,'Potholes on main road',3);
CALL RegisterComplaint(4,1,1,'No water supply',1);
CALL RegisterComplaint(5,2,2,'Street lights not working',2);
CALL RegisterComplaint(1,3,3,'Broken road divider',3);
CALL RegisterComplaint(2,1,1,'Water overflow',1);
CALL RegisterComplaint(3,2,2,'Voltage fluctuation',2);
CALL RegisterComplaint(4,3,3,'Damaged road sign',3);
CALL RegisterComplaint(5,1,1,'Dirty water supply',1);
CALL RegisterComplaint(1,2,2,'Frequent power cuts',2);
CALL RegisterComplaint(2,3,3,'Cracked pavement',3);
CALL RegisterComplaint(3,1,1,'Pipe leakage',1);
CALL RegisterComplaint(4,2,2,'Transformer issue',2);
CALL RegisterComplaint(5,3,3,'Road blockage',3);

-- ======================
-- UPDATES
-- ======================

INSERT INTO ComplaintUpdate (ComplaintID, Remarks, UpdatedBy)
VALUES 
(1,'Complaint registered','System'),
(2,'Work started','Officer'),
(3,'Under review','Officer');

-- ======================
-- OUTPUT QUERIES
-- ======================

-- 1. View all complaints
SELECT * FROM Complaint;

-- 2. Full system output
SELECT 
    c.ComplaintID,
    ct.Name AS Citizen,
    cat.CategoryName,
    d.DepartmentName,
    o.OfficerName,
    c.Status,
    c.SLADedline
FROM Complaint c
JOIN Citizen ct ON c.CitizenID = ct.CitizenID
JOIN Category cat ON c.CategoryID = cat.CategoryID
JOIN Department d ON c.DepartmentID = d.DepartmentID
JOIN Officer o ON c.OfficerID = o.OfficerID;

-- 3. Overdue complaints
SELECT *
FROM Complaint
WHERE SLADedline < CURDATE()
AND Status != 'Resolved';
UPDATE Complaint
SET SLADedline = CURDATE() - INTERVAL 1 DAY
WHERE ComplaintID = 1;
-- 4. Complaint updates
SELECT * FROM Complaint
WHERE SLADedline < CURDATE();
