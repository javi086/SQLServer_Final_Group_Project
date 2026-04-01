/*=============================================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Jose Javier Santana Vera

  This view provides sales information from all countries
==============================================================================================*/

CREATE VIEW Reports.v_executive_global_sales
AS
SELECT 
    o.order_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    co.country_name,
    o.total_amount AS local_amount,
    o.currency_code,
    (o.total_amount * er.rate) AS total_in_cad,
    o.order_date
FROM Reports.order_info o
JOIN Reports.customer c ON o.customer_id = c.customer_id
JOIN Reports.country co ON o.country_id = co.country_id
JOIN Reports.exchange_rate er ON o.currency_code = er.from_currency
WHERE er.to_currency = 'CAD';
GO