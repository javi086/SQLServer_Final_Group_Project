/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Tandin Phurba
  Std No: N01654961

====================================================================*/

CREATE OR ALTER PROCEDURE Reports.sp_orders_by_country
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        c.country_name,
        COUNT(o.order_id) AS TotalOrders
    FROM Reports.order_info o
    JOIN Reports.country c
        ON o.country_id = c.country_id
    GROUP BY c.country_name
    ORDER BY TotalOrders DESC;
END;
GO

EXEC Reports.sp_orders_by_country;