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

    -- Get the discount value from our promotion table
    SELECT @promo_id = promotion_id, @discount = discount_value 
    FROM promotion  WHERE promotion_code = @promotion_code;

    IF @promo_id IS NOT NULL
    BEGIN
        UPDATE order_info SET promotion_id = @promo_id, total_amount = total_amount - (total_amount * (@discount / 100))
        WHERE order_id = @order_id;
        PRINT 'Promotion applied successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Invalid Promotion Code.';
    END
END;
GO



