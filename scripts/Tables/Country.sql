/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Jose Javier Santana Vera
====================================================================*/


CREATE TABLE Reports.country (
    country_id          INT IDENTITY(1,1),
    country_name        VARCHAR(50) NOT NULL,
    country_code        CHAR(3) NOT NULL,
    currency_code       CHAR(3) NOT NULL,

    CONSTRAINT PK_Reports_country             PRIMARY KEY CLUSTERED (country_id),
    CONSTRAINT UQ_Reports_country_name        UNIQUE (country_name),
    CONSTRAINT UQ_Reports_country_code        UNIQUE (country_code)
);
GO