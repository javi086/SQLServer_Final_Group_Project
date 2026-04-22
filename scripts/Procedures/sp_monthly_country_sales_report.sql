/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Tandin Phurba
  Std No: N01654961

====================================================================*/

USE master;
GO

/* =========================================================
   1) CHECK CONSTRAINT
   Ensure exchange rates are always positive
   ========================================================= */
IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_exchange_rate_positive'
)
BEGIN
    ALTER TABLE Reports.exchange_rate
    ADD CONSTRAINT CK_exchange_rate_positive
    CHECK (rate > 0);
END;
GO

/* =========================================================
   2) DETAILED VIEW
   Shows each order with customer, country, local amount,
   currency, converted CAD amount, and order date.
   Uses the latest exchange rate for each currency.
   ========================================================= */
CREATE OR ALTER VIEW Reports.v_monthly_order_details AS
SELECT
    o.order_id,
    cu.first_name + ' ' + cu.last_name AS customer_name,
    c.country_name,
    o.total_amount AS local_amount,
    o.currency_code,
    o.total_amount * er.rate AS total_in_cad,
    o.order_date
FROM Reports.order_info o
JOIN Reports.customer cu
    ON o.customer_id = cu.customer_id
JOIN Reports.country c
    ON o.country_id = c.country_id
JOIN Reports.exchange_rate er
    ON er.from_currency = o.currency_code
   AND er.to_currency = 'CAD'
   AND er.effective_date = (
        SELECT MAX(er2.effective_date)
        FROM Reports.exchange_rate er2
        WHERE er2.from_currency = o.currency_code
          AND er2.to_currency = 'CAD'
   );
GO

/* =========================================================
   3) STORED PROCEDURE
   Monthly summary report by country and currency.
   Converts sales into CAD using the latest exchange rate.
   ========================================================= */
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
       AND er.effective_date = (
            SELECT MAX(er2.effective_date)
            FROM Reports.exchange_rate er2
            WHERE er2.from_currency = o.currency_code
              AND er2.to_currency = 'CAD'
       )
    WHERE YEAR(o.order_date) = @SalesYear
      AND MONTH(o.order_date) = @SalesMonth
    GROUP BY
        c.country_name,
        o.currency_code
    ORDER BY
        TotalSalesCAD DESC;
END;
GO

-- Detailed order-level view
SELECT * FROM Reports.v_monthly_order_details;
GO

-- Monthly summary report example
EXEC Reports.sp_monthly_country_sales_report 2026, 4;
GO
