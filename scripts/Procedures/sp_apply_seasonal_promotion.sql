/*=============================================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Jose Javier Santana Vera

  This procedure allows to handle the logic to apply promotion code and the update records
==============================================================================================*/

CREATE PROCEDURE Reports.sp_apply_seasonal_promotion
    @order_id INT,
    @promotion_code VARCHAR(20)
AS
BEGIN
    DECLARE @discount DECIMAL(5,2);
    DECLARE @promo_id INT;
    DECLARE @start_date DATE;
    DECLARE @end_date DATE;

    -- Get the discount value and validity window from our promotion table
    SELECT @promo_id = promotion_id,
           @discount = discount_value,
           @start_date = start_date,
           @end_date = end_date
    FROM Reports.promotion  WHERE promotion_code = @promotion_code;

    IF @promo_id IS NULL
    BEGIN
        PRINT 'Invalid Promotion Code.';
        RETURN;
    END

    -- Reject expired or not-yet-active promotions
    IF CAST(GETDATE() AS DATE) < @start_date
       OR (@end_date IS NOT NULL AND CAST(GETDATE() AS DATE) > @end_date)
    BEGIN
        PRINT 'Promotion Code is not active for the current date.';
        RETURN;
    END

    UPDATE Reports.order_info
    SET promotion_id = @promo_id,
        total_amount = total_amount - (total_amount * (@discount / 100))
    WHERE order_id = @order_id;
    PRINT 'Promotion applied successfully.';
END;
GO



