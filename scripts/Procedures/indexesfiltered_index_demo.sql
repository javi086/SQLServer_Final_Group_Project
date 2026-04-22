IF EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_high_value_orders'
    AND object_id = OBJECT_ID('Reports.order_info')
)
DROP INDEX Reports.idx_high_value_orders ON Reports.order_info;
GO

--- Baseline Performance (BEFORE Index) ---
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT order_id, customer_id, order_date, total_amount
FROM Reports.order_info
WHERE total_amount > 1000;  --- This query currently scans the table because no filtered index exists ---
GO

--- Show Execution Plan (Before) ---
SET SHOWPLAN_TEXT ON;
GO

SELECT order_id, customer_id, order_date, total_amount
FROM Reports.order_info
WHERE total_amount > 1000;

GO
SET SHOWPLAN_TEXT OFF;
GO

CREATE NONCLUSTERED INDEX Reports.idx_high_value_orders
ON Reports.order_info(order_id)
INCLUDE (customer_id, order_date, total_amount)
WHERE total_amount > 1000;   --- This index only stores high-value orders, reducing index size and improving performance. ---
GO

--- Performance After Index ---
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT order_id, customer_id, order_date, total_amount
FROM Reports.order_info
WHERE total_amount > 1000;   --- Logical reads and execution time are reduced after applying the filtered index ---
GO

--- Execution Plan After Index ---
SET SHOWPLAN_TEXT ON;
GO

SELECT order_id, customer_id, order_date, total_amount
FROM Reports.order_info
WHERE total_amount > 1000;

GO
SET SHOWPLAN_TEXT OFF;
GO

--- Limitations ---
SELECT order_id, customer_id, order_date, total_amount
FROM Reports.order_info
WHERE total_amount <= 1000;  --- The filtered index is not used here because the condition does not match the filter ---
GO