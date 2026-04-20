/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Jose Javier Santana Vera


  This is a non-clustered index to facilitate the location of seasonal codes
====================================================================*/

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'idx_promotion_code_lookup')
    DROP INDEX idx_promotion_code_lookup ON Reports.promotion;
GO

CREATE NONCLUSTERED INDEX idx_promotion_code_lookup
ON Reports.promotion (promotion_code)
INCLUDE (discount_value);
GO



/*
Evidence 
SELECT promotion_code, discount_value FROM Reports.promotion WHERE promotion_code = 'BLACKFRIDAY';
*/