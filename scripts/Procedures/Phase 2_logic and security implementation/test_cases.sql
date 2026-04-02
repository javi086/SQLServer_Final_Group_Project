/*=============================================================================================
  FILE: test_cases.sql

  DESCRIPTION:
  This script creates test data and validates all functions and views
  in the Reports database.

  PURPOSE:
  - Insert sample data
  - Test functions
  - Validate views
  - Ensure system behaves correctly

==============================================================================================*/

INSERT INTO Reports.country (country_name, country_code, currency_code)
VALUES ('Canada', 'CAN', 'CAD');

INSERT INTO Reports.promotion (promotion_code, discount_value, start_date, end_date)
VALUES ('PROMO10', 10.00, '2026-01-01', '2026-12-31');

INSERT INTO Reports.customer (first_name, last_name, email, country_id, account_status)
VALUES ('John', 'Doe', 'john@test.com', 1, 'Active');

INSERT INTO Reports.order_info (customer_id, order_date, country_id, total_amount, currency_code, promotion_id)
VALUES (1, GETDATE(), 1, 1000.00, 'USD', 1);


SELECT Reports.fn_calculate_discount(1000.00, 1) AS discounted_amount;

SELECT 
    customer_id,
    first_name,
    last_name,
    order_id,
    order_date,
    total_amount
FROM Reports.v_customer_orders;