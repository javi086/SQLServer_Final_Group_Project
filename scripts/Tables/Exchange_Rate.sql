/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Jose Javier Santana Vera
====================================================================*/

CREATE TABLE Exchange_Rate (
    ExchangeRateId INT IDENTITY(1,1),
    FromCurrency CHAR(3) NOT NULL,
    ToCurrency CHAR(3) DEFAULT 'CAD',
    Rate DECIMAL(18,6) NOT NULL,
    EffectiveDate DATETIME DEFAULT GETDATE(),

    CONSTRAINT PK_ExchangeRate PRIMARY KEY CLUSTERED (ExchangeRateId)
);
GO