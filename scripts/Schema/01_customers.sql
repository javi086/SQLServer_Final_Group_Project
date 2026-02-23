CREATE TABLE Customer (
    CustomerId INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20),
    DateOfBirth DATE,
    Address VARCHAR(150),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50) NOT NULL,
    PostalCode VARCHAR(20),
    AccountStatus VARCHAR(20) NOT NULL CHECK (AccountStatus IN ('Active', 'Suspended', 'Cancelled')),
    SupportRepId INT,

    CONSTRAINT FK_Customer_SupportRep
        FOREIGN KEY (SupportRepId) REFERENCES Employee(EmployeeId)
);