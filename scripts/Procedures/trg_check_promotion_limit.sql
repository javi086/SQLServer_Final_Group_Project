/*=============================================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Jose Javier Santana Vera

  This trigger allows to control the max amount of discount which must not be less than 50%
==============================================================================================*/


CREATE TRIGGER Reports.trg_check_promotion_limit
ON Reports.promotion
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE discount_value > 50.00)
    BEGIN
        RAISERROR('Business Rule Violation: Promotions cannot exceed 50%%.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO