/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Jose Javier Santana Vera


  This procedure allows to handle the logic for the exchange rates
====================================================================*/



CREATE PROCEDURE Reports.sp_update_exchange_rate
    @currency CHAR(3),
    @new_rate DECIMAL(18,6)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT 1 FROM Reports.exchange_rate WHERE from_currency = @currency)
    BEGIN
        UPDATE Reports.exchange_rate
        SET rate = @new_rate,
            effective_date = GETDATE()
        WHERE from_currency = @currency;
        PRINT 'Rate updated for ' + @currency;
    END
    ELSE
    BEGIN
        PRINT 'Currency not found.';
    END
END;
GO