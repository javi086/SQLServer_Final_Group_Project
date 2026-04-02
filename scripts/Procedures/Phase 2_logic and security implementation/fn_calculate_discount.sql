/*=============================================================================================
  FUNCTION NAME: Reports.fn_calculate_discount

  DESCRIPTION:
  Calculates discounted order total based on promotion percentage.

  BUSINESS PURPOSE:
  - Apply promotional discounts
  - Support pricing automation
  - Ensure consistent discount logic

  LOGIC SUMMARY:
  - Retrieves discount_value from Reports.promotion
  - Applies percentage reduction to total amount

==============================================================================================*/

CREATE FUNCTION Reports.fn_calculate_discount
(
    @total DECIMAL(10,2),
    @promotion_id INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @discount DECIMAL(5,2);

    SELECT @discount = discount_value
    FROM Reports.promotion
    WHERE promotion_id = @promotion_id;

    RETURN @total - (@total * (@discount / 100));
END;
GO