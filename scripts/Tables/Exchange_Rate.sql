/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Jose Javier Santana Vera
====================================================================*/


CREATE TABLE Reports.exchange_rate (
    exchange_rate_id    INT IDENTITY(1,1),
    from_currency       CHAR(3) NOT NULL,
    to_currency         CHAR(3) DEFAULT 'CAD',
    rate                DECIMAL(18,6) NOT NULL,
    effective_date      DATETIME DEFAULT GETDATE(),

    CONSTRAINT PK_Reports_exchange_rate        PRIMARY KEY CLUSTERED (exchange_rate_id)
);
GO