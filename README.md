# Smart City Complaint Management System (DBMS Project)

## 📌 Overview

This project is a database system designed to manage complaints in a smart city. It allows citizens to register complaints, assigns them to departments and officers, and tracks resolution using SLA deadlines.

---

## 🚀 Features

* Citizen complaint registration
* Categorization of complaints
* Department & officer assignment
* SLA (Service Level Agreement) tracking
* Complaint status tracking (In Progress / Resolved)
* Complaint update history
* Detection of overdue complaints

---

## 🗄️ Database Design

Entities used:

* Citizen
* Complaint
* Category
* Department
* Officer
* SLA
* ComplaintUpdate

(Refer ER_Diagram.png)

---

## ⚙️ Technologies Used

* MySQL Workbench
* SQL (DDL, DML, Joins, Triggers, Procedures)

---

## 🔥 Advanced Concepts Used

* **Trigger** → Automatically sets SLA deadline
* **Stored Procedure** → Registers complaints
* **Joins** → Fetch complete complaint details
* **Constraints** → Maintain data integrity

---

## 📊 Sample Queries

### View all complaints

```sql
SELECT * FROM Complaint;
```

### Full system view

```sql
SELECT 
    c.ComplaintID,
    ct.Name AS Citizen,
    cat.CategoryName,
    d.DepartmentName,
    o.OfficerName,
    c.Status
FROM Complaint c
JOIN Citizen ct ON c.CitizenID = ct.CitizenID
JOIN Category cat ON c.CategoryID = cat.CategoryID
JOIN Department d ON c.DepartmentID = d.DepartmentID
JOIN Officer o ON c.OfficerID = o.OfficerID;
```

---

## 📸 Outputs

(Add screenshots in /screenshots folder)

---

## 🎯 Conclusion

This project demonstrates how DBMS can be used to efficiently manage real-world complaint systems with automation, tracking, and structured data handling.

---

## 👨‍💻 Author

Veeraj Ghalyan
