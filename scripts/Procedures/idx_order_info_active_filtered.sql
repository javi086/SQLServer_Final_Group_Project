/*====================================================================
  NAME : SUHANI MEHTA
  FILE: idx_order_info_active_filtered.sql
  TABLE: Reports.order_info
  PURPOSE: Filtered index covering only orders with promotions applied
  RUN AFTER: Order.sql
====================================================================*/

USE MultimediaSolutions;
GO

IF OBJECT_ID(N'Reports.order_info', N'U') IS NULL
BEGIN
    RAISERROR('Reports.order_info does not exist. Run Order.sql first.', 16, 1);
    RETURN;
END
GO

-- Drop if index already exists
IF EXISTS (
    SELECT 1 FROM sys.indexes 
    WHERE name = N'idx_order_info_active_filtered'
    AND object_id = OBJECT_ID(N'Reports.order_info')
)
    DROP INDEX idx_order_info_active_filtered ON Reports.order_info;
GO

CREATE NONCLUSTERED INDEX idx_order_info_active_filtered
ON Reports.order_info (customer_id, order_date)
INCLUDE (total_amount, currency_code, promotion_id, country_id)
WHERE promotion_id IS NOT NULL;
GO

PRINT 'idx_order_info_active_filtered created successfully.';
GO