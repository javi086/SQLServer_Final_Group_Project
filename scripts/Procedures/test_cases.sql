USE MultimediaSolutions;
GO

PRINT '==== TEST CASES START ====';
GO

/*========================================================
TEST 1: Function - Discount Calculation
========================================================*/
PRINT 'TEST 1: Discount Function';

SELECT Reports.fn_calculate_discount(1000.00, 1) AS discounted_amount;

-- EXPECTED:
-- 900.00 (based on promotion)


/*========================================================
TEST 2: View - Customer Orders
========================================================*/
PRINT 'TEST 2: Customer Orders View';

SELECT TOP 10 *
FROM Reports.v_customer_orders;

-- EXPECTED:
-- Customer names + order info


/*========================================================
TEST 3: View - Executive Sales
========================================================*/
PRINT 'TEST 3: Executive Sales View';

SELECT TOP 10 *
FROM Reports.v_executive_global_sales;

-- EXPECTED:
-- Includes CAD conversion


/*========================================================
TEST 4: Apply Promotion
========================================================*/
PRINT 'TEST 4: Apply Promotion';

SELECT order_id, total_amount, promotion_id
FROM Reports.order_info
WHERE order_id = 1;

EXEC Reports.sp_apply_seasonal_promotion
    @order_id = 1,
    @promotion_code = 'B2SCHOOL';

SELECT order_id, total_amount, promotion_id
FROM Reports.order_info
WHERE order_id = 1;

-- EXPECTED:
-- total_amount reduced
-- promotion_id updated


/*========================================================
TEST 5: Update Exchange Rate
========================================================*/
PRINT 'TEST 5: Update Exchange Rate';

SELECT * 
FROM Reports.exchange_rate
WHERE from_currency = 'AUD';

EXEC Reports.sp_update_exchange_rate
    @currency = 'AUD',
    @new_rate = 0.950000;

SELECT * 
FROM Reports.exchange_rate
WHERE from_currency = 'AUD';

-- EXPECTED:
-- rate updated


/*========================================================
TEST 6: Invalid Promotion (BUSINESS RULE)
========================================================*/
PRINT 'TEST 6: Invalid Promotion';

BEGIN TRY
    INSERT INTO Reports.promotion (promotion_code, discount_value, start_date)
    VALUES ('BADPROMO', 60.00, GETDATE());

    PRINT 'FAIL: Insert should not work';
END TRY
BEGIN CATCH
    PRINT 'PASS: Promotion blocked';
END CATCH;

-- EXPECTED:
-- FAIL prevented (over 50%)


/*========================================================
TEST 7: Invalid Promotion Code
========================================================*/
PRINT 'TEST 7: Invalid Promotion Code';

BEGIN TRY
    EXEC Reports.sp_apply_seasonal_promotion
        @order_id = 2,
        @promotion_code = 'INVALID';

    PRINT 'FAIL: Should not succeed';
END TRY
BEGIN CATCH
    PRINT 'PASS: Error thrown correctly';
END CATCH;


/*========================================================
TEST 8: Reporting Workflow
========================================================*/
PRINT 'TEST 8: Reporting Workflow';

SELECT TOP 5 *
FROM Reports.v_executive_global_sales
ORDER BY order_id;

-- EXPECTED:
-- Data visible for executives


PRINT '==== TEST CASES COMPLETE ====';
GO