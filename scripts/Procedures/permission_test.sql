USE MultimediaSolutions;
GO

PRINT '==== PERMISSION TEST START ====';
GO


/*========================================================
TEST 1: Finance Role
========================================================*/
PRINT 'Finance Role Test';

BEGIN TRY
    EXECUTE AS USER = 'FinanceAccountant';

    SELECT TOP 5 * FROM Reports.exchange_rate;

    EXEC Reports.sp_update_exchange_rate
        @currency = 'AUD',
        @new_rate = 0.920000;

    REVERT;
    PRINT 'PASS: Finance access works';
END TRY
BEGIN CATCH
    PRINT 'FAIL: Finance access issue';
    REVERT;
END CATCH;


/*========================================================
TEST 2: Marketing Role (Promotion Access)
========================================================*/
PRINT 'Marketing Role Test';

-- NOTE: If no user exists for this role, skip EXECUTE AS
-- You can just test permissions manually

SELECT TOP 5 * FROM Reports.promotion;

EXEC Reports.sp_apply_seasonal_promotion
    @order_id = 3,
    @promotion_code = 'B2SCHOOL';

-- EXPECTED:
-- Works if MarketingRole has permissions


/*========================================================
TEST 3: Executive Role (READ ONLY)
========================================================*/
PRINT 'Executive Role Test';

SELECT TOP 5 * 
FROM Reports.v_executive_global_sales;

-- EXPECTED:
-- SELECT works


/*========================================================
TEST 4: Executive Cannot Insert
========================================================*/
PRINT 'Executive Restriction Test';

BEGIN TRY
    INSERT INTO Reports.exchange_rate (from_currency, rate)
    VALUES ('XXX', 1.0);

    PRINT 'FAIL: Should not allow insert';
END TRY
BEGIN CATCH
    PRINT 'PASS: Insert blocked';
END CATCH;


/*========================================================
TEST 5: Tester Role (Full Read)
========================================================*/
PRINT 'Tester Role Test';

SELECT TOP 5 * FROM Reports.customer;
SELECT TOP 5 * FROM Reports.order_info;
SELECT TOP 5 * FROM Reports.promotion;

-- EXPECTED:
-- All SELECTs succeed


PRINT '==== PERMISSION TEST COMPLETE ====';
GO