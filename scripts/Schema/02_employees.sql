CREATE TABLE Employee (
    EmployeeId INT IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    JobTitle VARCHAR(100) NOT NULL,
    Department VARCHAR(100) NOT NULL,
    ReportsTo INT NULL,
    HireDate DATE NOT NULL,
    EmploymentStatus VARCHAR(20) NOT NULL,
    WorkEmail VARCHAR(100) NOT NULL,
    CountryId INT NOT NULL,

    CONSTRAINT PK_Employee PRIMARY KEY CLUSTERED (EmployeeId),
    CONSTRAINT UQ_Employee_Email UNIQUE (WorkEmail), 
    CONSTRAINT FK_Employee_Manager  FOREIGN KEY (ReportsTo) REFERENCES Employee(EmployeeId),
    CONSTRAINT FK_Employee_Country  FOREIGN KEY (CountryId) REFERENCES Country(CountryId),
    CONSTRAINT CK_Employee_Status CHECK (EmploymentStatus IN ('Active', 'Inactive'))
);
GO