/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Tandin Phurba
  Std No: N01654961

====================================================================*/


SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_NAME;

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS;

SELECT name
FROM sys.procedures;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'order_info';

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_SCHEMA, TABLE_NAME;

SELECT * FROM Reports.country;
SELECT * FROM Reports.customer;
SELECT * FROM Reports.employee;

CREATE OR ALTER PROCEDURE Reports.sp_monthly_country_sales_report
    @SalesYear INT,
    @SalesMonth INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        c.country_name AS CountryName,
        o.currency_code AS CurrencyCode,
        COUNT(o.order_id) AS TotalOrders,
        SUM(o.total_amount) AS TotalSalesLocalCurrency,
        MAX(er.rate) AS ExchangeRateToCAD,
        SUM(o.total_amount * er.rate) AS TotalSalesCAD
    FROM Reports.order_info o
    JOIN Reports.customer cu
        ON o.customer_id = cu.customer_id
    JOIN Reports.country c
        ON o.country_id = c.country_id
    JOIN Reports.exchange_rate er
        ON er.from_currency = o.currency_code   
       AND er.to_currency = 'CAD'               
    WHERE YEAR(o.order_date) = @SalesYear
      AND MONTH(o.order_date) = @SalesMonth
    GROUP BY
        c.country_name,
        o.currency_code;
END;
GO

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Reports'
  AND TABLE_NAME = 'exchange_rate';
GO

SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'Reports';

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Reports'
  AND TABLE_NAME = 'order_info';
GO

INSERT INTO Reports.order_info
(customer_id, order_date, billing_address, billing_city, country_id, total_amount, currency_code, promotion_id)
VALUES
(1, '2026-04-10', '123 Maple St', 'Toronto', 1, 113.00, 'CAD', NULL),
(2, '2026-04-15', '456 Main St', 'New York', 2, 226.00, 'USD', NULL);
GO

EXEC Reports.sp_monthly_country_sales_report 2026, 4;
GO

SELECT * FROM Reports.order_info;
SELECT * FROM Reports.exchange_rate;
GO

INSERT INTO Reports.exchange_rate
(from_currency, to_currency, rate, effective_date)
VALUES
('CAD', 'CAD', 1.00, '2026-04-01'),
('USD', 'CAD', 1.35, '2026-04-01');
GO

INSERT INTO Reports.exchange_rate
(from_currency, to_currency, rate, effective_date)
VALUES
('MXN', 'CAD', 0.08, '2026-04-01'),
('INR', 'CAD', 0.016, '2026-04-01'),
('GBP', 'CAD', 1.72, '2026-04-01'),
('CNY', 'CAD', 0.19, '2026-04-01'),
('BRL', 'CAD', 0.27, '2026-04-01'),
('JPY', 'CAD', 0.009, '2026-04-01');
GO

SELECT * FROM Reports.exchange_rate;
GO

EXEC Reports.sp_monthly_country_sales_report 2026, 4;
GO

ALTER TABLE Reports.exchange_rate
ADD CONSTRAINT CK_exchange_rate_positive
CHECK (rate > 0);
GO

INSERT INTO Reports.exchange_rate
(from_currency, to_currency, rate, effective_date)
VALUES ('USD','CAD', -5, '2026-04-01');

INSERT INTO Reports.exchange_rate
(from_currency, to_currency, rate, effective_date)
VALUES ('USD','CAD', 1.40, '2026-05-01');
GO

SELECT * FROM Reports.exchange_rate;
GO
