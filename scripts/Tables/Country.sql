/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Jose Javier Santana Vera
====================================================================*/
USE MultimediaSolutions;
GO;

CREATE TABLE Country (
    CountryId INT IDENTITY(1,1),
    CountryName VARCHAR(50) NOT NULL,
    CountryCode CHAR(3) NOT NULL,
    CurrencyCode CHAR(3) NOT NULL,

    CONSTRAINT PK_Country PRIMARY KEY CLUSTERED (CountryId),
    CONSTRAINT UQ_Country_Name UNIQUE (CountryName),
    CONSTRAINT UQ_Country_Code UNIQUE (CountryCode)
);
GO