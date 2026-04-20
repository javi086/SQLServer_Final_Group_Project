/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Jose Javier Santana Vera


  Grande control access/privileges to specific roles 
====================================================================*/
USE MultimediaSolutions;
GO



/*====================================================================
     ROLES
====================================================================*/

-- TesterUser
IF DATABASE_PRINCIPAL_ID('TesterUser') IS NULL
    CREATE ROLE TesterUser;
GO

-- Financial
IF DATABASE_PRINCIPAL_ID('FinanceRole') IS NULL
    CREATE ROLE FinanceRole;
GO

-- Marketing
IF DATABASE_PRINCIPAL_ID('MarketingRole') IS NULL
    CREATE ROLE MarketingRole;
GO

-- Executive
IF DATABASE_PRINCIPAL_ID('ExecutiveRole') IS NULL
    CREATE ROLE ExecutiveRole;
GO



/*====================================================================
     PERMISSION
====================================================================*/

-- Finance Role: Needs to manage rates and see global revenue
GRANT SELECT, UPDATE ON Reports.exchange_rate TO FinanceRole;
GRANT EXECUTE ON Reports.sp_update_exchange_rate TO FinanceRole;
GRANT SELECT ON Reports.v_executive_global_sales TO FinanceRole;

-- Marketing Role: Needs to manage seasonal promotions
GRANT SELECT, INSERT, UPDATE ON Reports.promotion TO MarketingRole;
GRANT EXECUTE ON Reports.sp_apply_seasonal_promotion TO MarketingRole;

-- Executive Role: Read-only access to high-level reports
GRANT SELECT ON Reports.v_executive_global_sales TO ExecutiveRole;

-- Tester User: Full read access to the schema for validation
GRANT SELECT ON SCHEMA::Reports TO TesterUser;
GO



EXECUTE AS USER = 'TesterUser';
