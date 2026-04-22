/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Tandin Phurba
  Std No: N01654961

====================================================================*/

CREATE OR ALTER PROCEDURE Reports.sp_top_customers_by_sales
    @TopN INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@TopN)
        cu.first_name + ' ' + cu.last_name AS CustomerName,
        COUNT(o.order_id) AS TotalOrders,
        SUM(o.total_amount) AS TotalLocalAmount,
        SUM(o.total_amount * er.rate) AS TotalSalesCAD
    FROM Reports.order_info o
    JOIN Reports.customer cu
        ON o.customer_id = cu.customer_id
    JOIN Reports.exchange_rate er
        ON er.from_currency = o.currency_code
       AND er.to_currency = 'CAD'
       AND er.effective_date = (
            SELECT MAX(er2.effective_date)
            FROM Reports.exchange_rate er2
            WHERE er2.from_currency = o.currency_code
              AND er2.to_currency = 'CAD'
       )
    GROUP BY
        cu.first_name,
        cu.last_name
    ORDER BY
        TotalSalesCAD DESC;
END;
GO

EXEC Reports.sp_top_customers_by_sales 5;
GO