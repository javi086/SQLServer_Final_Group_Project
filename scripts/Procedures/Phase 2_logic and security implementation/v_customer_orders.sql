/*=============================================================================================
  VIEW NAME: Reports.v_customer_orders

  DESCRIPTION:
  Displays customer information along with their order history.

  BUSINESS PURPOSE:
  - Provide quick access to customer purchase history
  - Support customer service operations
  - Enable sales reporting

  LOGIC SUMMARY:
  - Joins customer and order tables
  - Returns only customers who placed orders

==============================================================================================*/

CREATE VIEW Reports.v_customer_orders
AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    oi.order_id,
    oi.order_date,
    oi.total_amount
FROM Reports.customer c
JOIN Reports.order_info oi ON c.customer_id = oi.customer_id;
GO