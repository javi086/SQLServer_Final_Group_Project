CREATE TABLE Employee (
    EmployeeId INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    JobTitle VARCHAR(100) NOT NULL,
    Department VARCHAR(100) NOT NULL,
    ReportsTo INT NULL,
    HireDate DATE NOT NULL,
    EmploymentStatus VARCHAR(20) NOT NULL CHECK (EmploymentStatus IN ('Active', 'Inactive')),
    WorkEmail VARCHAR(100) NOT NULL UNIQUE,
    WorkPhone VARCHAR(20),
    OfficeLocation VARCHAR(100),
    AccessRole VARCHAR(50) NOT NULL,
    
    CONSTRAINT FK_Employee_Manager
        FOREIGN KEY (ReportsTo) REFERENCES Employee(EmployeeId)
);