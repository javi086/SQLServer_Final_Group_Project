/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Jose Javier Santana Vera


  This is a non-clustered index to speed up the Join in v_executive_global_sales and the Update Procedure
====================================================================*/

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'idx_exchange_rate_currencies')
    DROP INDEX idx_exchange_rate_currencies ON Reports.exchange_rate;
GO

CREATE NONCLUSTERED INDEX idx_exchange_rate_currencies
ON Reports.exchange_rate (from_currency, to_currency)
INCLUDE (rate, effective_date);
GO

SELECT * FROM Reports.v_executive_global_sales WITH (INDEX(idx_exchange_rate_currencies));

