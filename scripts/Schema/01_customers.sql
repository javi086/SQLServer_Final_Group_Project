CREATE TABLE Customer (
    CustomerId INT IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20),
    DateOfBirth DATE,
    Address VARCHAR(150),
    City VARCHAR(50),
    State VARCHAR(50),
    CountryId INT NOT NULL,
    PostalCode VARCHAR(20),
    AccountStatus VARCHAR(20) NOT NULL,
    SupportRepId INT,

    CONSTRAINT PK_Customer PRIMARY KEY CLUSTERED (CustomerId),
    CONSTRAINT UQ_Customer_Email UNIQUE (Email),
    CONSTRAINT FK_Customer_Country FOREIGN KEY (CountryId) REFERENCES Country(CountryId),
    CONSTRAINT FK_Customer_SupportRep FOREIGN KEY (SupportRepId) REFERENCES Employee(EmployeeId),
    CONSTRAINT CK_Customer_Status CHECK (AccountStatus IN ('Active', 'Suspended', 'Cancelled'))
);
GO