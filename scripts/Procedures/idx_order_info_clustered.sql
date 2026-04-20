/*====================================================================
  NAME : SUHANI MEHTA
  FILE: idx_order_info_clustered.sql
  TABLE: Reports.order_info
  PURPOSE: Clustered index to optimize customer order history queries
           and the v_executive_global_sales view JOIN on customer_id
====================================================================*/

-- Step 1: Drop the existing PK (which is currently clustered)
ALTER TABLE Reports.order_info
    DROP CONSTRAINT PK_Reports_order_info;
GO

-- Step 2: Re-add PK as NON-clustered so we can cluster on a better key
ALTER TABLE Reports.order_info
    ADD CONSTRAINT PK_Reports_order_info PRIMARY KEY NONCLUSTERED (order_id);
GO

-- Step 3: Create the clustered index on (customer_id, order_date)
CREATE CLUSTERED INDEX CIX_order_info_customer_date
ON Reports.order_info (customer_id, order_date DESC);
GO

/*
  WHY THIS TABLE AND THESE COLUMNS:
  - order_info is the central fact table: it joins to customer,
    country, promotion, and exchange_rate
  - The two views (v_executive_global_sales, v_customer_orders) both
    JOIN on customer_id — clustering on it eliminates random I/O
  - order_date DESC puts the most recent orders first, matching how
    reports and the executive view will naturally query the data
  - sp_apply_seasonal_promotion also looks up by order_id, which
    remains covered by the non-clustered PK
*/