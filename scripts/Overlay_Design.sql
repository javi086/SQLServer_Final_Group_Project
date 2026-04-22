/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions

  RULES:
   - DO NOT modify base MultimediaSolutions tables
   - All custom objects MUST live under schema: Reports
====================================================================*/
USE MultimediaSolutions;
GO

/*====================================================================
     1. PRE-FLIGHT & SCHEMA SETUP
====================================================================*/
IF DB_ID(N'MultimediaSolutions') IS NULL
BEGIN
    RAISERROR('MultimediaSolutions database not found. Please restore it first.', 16, 1);
    RETURN;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Reports')
BEGIN
    EXEC(N'CREATE SCHEMA Reports AUTHORIZATION dbo;');
END
GO

/*====================================================================
     2. CLEANUP (Drop existing objects to allow re-runs)
====================================================================*/
-- Drop Roles (Must drop users/members first if assigned)
IF DATABASE_PRINCIPAL_ID('FinanceRole') IS NOT NULL DROP ROLE FinanceRole;
IF DATABASE_PRINCIPAL_ID('MarketingRole') IS NOT NULL DROP ROLE MarketingRole;
IF DATABASE_PRINCIPAL_ID('ExecutiveRole') IS NOT NULL DROP ROLE ExecutiveRole;
IF DATABASE_PRINCIPAL_ID('TesterUser') IS NOT NULL DROP ROLE TesterUser;

-- Drop Test User
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'FinanceAccountant')
    DROP USER FinanceAccountant;
GO

-- Drop Views
IF OBJECT_ID(N'Reports.v_customer_orders', N'V') IS NOT NULL DROP VIEW Reports.v_customer_orders;
IF OBJECT_ID(N'Reports.v_executive_global_sales', N'V') IS NOT NULL DROP VIEW Reports.v_executive_global_sales;

-- Drop Procedures
IF OBJECT_ID(N'Reports.sp_apply_seasonal_promotion', N'P') IS NOT NULL DROP PROCEDURE Reports.sp_apply_seasonal_promotion;
IF OBJECT_ID(N'Reports.sp_update_exchange_rate', N'P') IS NOT NULL DROP PROCEDURE Reports.sp_update_exchange_rate;

-- Drop Tables (Child tables first)
IF OBJECT_ID(N'Reports.order_details', N'U') IS NOT NULL DROP TABLE Reports.order_details;
IF OBJECT_ID(N'Reports.order_info', N'U') IS NOT NULL DROP TABLE Reports.order_info;
IF OBJECT_ID(N'Reports.customer', N'U') IS NOT NULL DROP TABLE Reports.customer;
IF OBJECT_ID(N'Reports.employee', N'U') IS NOT NULL DROP TABLE Reports.employee;
IF OBJECT_ID(N'Reports.country', N'U') IS NOT NULL DROP TABLE Reports.country;
IF OBJECT_ID(N'Reports.promotion', N'U') IS NOT NULL DROP TABLE Reports.promotion;
IF OBJECT_ID(N'Reports.exchange_rate', N'U') IS NOT NULL DROP TABLE Reports.exchange_rate;
IF OBJECT_ID(N'Reports.trg_check_promotion_limit', N'TR') IS NOT NULL DROP TRIGGER Reports.trg_check_promotion_limit;

GO

/*====================================================================
     3. TABLE CREATION (Standardized & Fixed)
====================================================================*/
-- Country Table
CREATE TABLE Reports.country (
    country_id INT IDENTITY(1,1) NOT NULL,
    country_name VARCHAR(50) NOT NULL,
    country_code CHAR(3) NOT NULL,
    currency_code CHAR(3) NOT NULL,
    CONSTRAINT PK_Reports_country PRIMARY KEY CLUSTERED (country_id),
    CONSTRAINT UQ_Reports_country_name UNIQUE (country_name),
    CONSTRAINT UQ_Reports_country_code UNIQUE (country_code)
);

-- Promotion Table
CREATE TABLE Reports.promotion (
    promotion_id INT IDENTITY(1,1) NOT NULL,
    promotion_code VARCHAR(20) NOT NULL,
    discount_value DECIMAL(5,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    CONSTRAINT PK_Reports_promotion PRIMARY KEY CLUSTERED (promotion_id),
    CONSTRAINT UQ_Reports_promotion_code UNIQUE (promotion_code),
    CONSTRAINT CK_Reports_promotion_discount CHECK (discount_value <= 50.00)
);

-- Exchange Rate Table (FIXED - Column-level defaults)
CREATE TABLE Reports.exchange_rate (
    exchange_rate_id INT IDENTITY(1,1) NOT NULL,
    from_currency CHAR(3) NOT NULL,
    to_currency CHAR(3) NOT NULL DEFAULT 'CAD',      
    rate DECIMAL(18,6) NOT NULL,
    effective_date DATETIME NOT NULL DEFAULT GETDATE(),  
    CONSTRAINT PK_Reports_exchange_rate PRIMARY KEY CLUSTERED (exchange_rate_id)
);

-- Employee Table
CREATE TABLE Reports.employee (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    reports_to INT NULL REFERENCES Reports.employee(employee_id),
    country_id INT NOT NULL REFERENCES Reports.country(country_id),
    work_email VARCHAR(100) NOT NULL UNIQUE
);

-- Customer Table
CREATE TABLE Reports.customer (
    customer_id INT IDENTITY(1,1) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    account_status VARCHAR(20) NOT NULL,
    support_rep_id INT NULL,
    country_id INT NULL,
    CONSTRAINT PK_Reports_customer PRIMARY KEY CLUSTERED (customer_id),
    CONSTRAINT UQ_Reports_customer_email UNIQUE (email),
    CONSTRAINT CK_Reports_customer_status CHECK (account_status IN ('Active', 'Suspended', 'Cancelled')),
    CONSTRAINT FK_Reports_customer_employee FOREIGN KEY (support_rep_id) 
        REFERENCES Reports.employee(employee_id),
    CONSTRAINT FK_Reports_customer_country FOREIGN KEY (country_id) 
        REFERENCES Reports.country(country_id)
);

-- Order Info Table
CREATE TABLE Reports.order_info (
    order_id INT IDENTITY(1,1) NOT NULL,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    currency_code CHAR(3) NOT NULL,
    promotion_id INT NULL,
    country_id INT NULL,
    CONSTRAINT PK_Reports_order_info PRIMARY KEY NONCLUSTERED (order_id),
    CONSTRAINT FK_Reports_order_info_customer FOREIGN KEY (customer_id) 
        REFERENCES Reports.customer(customer_id),
    CONSTRAINT FK_Reports_order_info_promotion FOREIGN KEY (promotion_id) 
        REFERENCES Reports.promotion(promotion_id),
    CONSTRAINT FK_Reports_order_info_country FOREIGN KEY (country_id) 
        REFERENCES Reports.country(country_id)
);

-- Order Details Table
CREATE TABLE Reports.order_details (
    order_detail_id INT IDENTITY(1,1) NOT NULL,
    order_id INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT PK_Reports_order_details PRIMARY KEY CLUSTERED (order_detail_id),
    CONSTRAINT FK_Reports_order_details_order FOREIGN KEY (order_id) 
        REFERENCES Reports.order_info(order_id),
    CONSTRAINT CK_Reports_order_details_quantity CHECK (quantity > 0)
);
GO

/*====================================================================
     4. DATA POPULATION (Seed Data)
====================================================================*/
-- Country
INSERT INTO Reports.country (country_name, country_code, currency_code) 
VALUES
    ('France', 'FRA', 'EUR'),
    ('Italy', 'ITA', 'EUR'),
    ('Spain', 'ESP', 'EUR'),
    ('Australia', 'AUS', 'AUD'),
    ('South Korea', 'KOR', 'KRW'),
    ('Argentina', 'ARG', 'ARS'),
    ('Colombia', 'COL', 'COP'),
    ('South Africa', 'ZAF', 'ZAR'),
    ('Egypt', 'EGY', 'EGP'),
    ('Turkey', 'TUR', 'TRY'),
    ('Netherlands', 'NLD', 'EUR'),
    ('Switzerland', 'CHE', 'CHF'),
    ('Sweden', 'SWE', 'SEK'),
    ('Norway', 'NOR', 'NOK'),
    ('Poland', 'POL', 'PLN');
GO

-- Employee
INSERT INTO Reports.employee (first_name, last_name, work_email, country_id) 
VALUES
    ('Robert', 'Taylor', 'robert.t@multimedia.ca', 1),
    ('Linda', 'Johnson', 'linda.j@multimedia.us', 2),
    ('Miguel', 'Hernandez', 'miguel.h@multimedia.mx', 3),
    ('Sanjay', 'Gupta', 'sanjay.g@multimedia.in', 4),
    ('Dmitry', 'Sokolov', 'dmitry.s@multimedia.ru', 5),
    ('Li', 'Zheng', 'li.z@multimedia.cn', 6),
    ('Adriana', 'Lima', 'adriana.l@multimedia.br', 7),
    ('Oliver', 'Brown', 'oliver.b@multimedia.uk', 8),
    ('Sophia', 'Muller', 'sophia.m@multimedia.de', 9),
    ('Takumi', 'Sato', 'takumi.s@multimedia.jp', 10),
    ('Emma', 'Wilson', 'emma.w@multimedia.ca', 1),
    ('Lucas', 'Garcia', 'lucas.g@multimedia.es', 9),
    ('Amara', 'Kaur', 'amara.k@multimedia.in', 4),
    ('Ivan', 'Petrov', 'ivan.p@multimedia.ru', 5);

-- Customer
INSERT INTO Reports.customer (first_name, last_name, email, account_status, country_id, support_rep_id) 
VALUES
    ('Marco', 'Polo', 'marco.p@explorer.it', 'Active', 9, 3),
    ('Elena', 'Vance', 'elena.v@blackmesa.com', 'Active', 2, 11),
    ('Arthur', 'Morgan', 'arthur.m@van-der-linde.us', 'Suspended', 2, 8),
    ('Jill', 'Valentine', 'jill.v@stars.jp', 'Active', 10, 10),
    ('Leon', 'Kennedy', 'leon.k@rpd.us', 'Active', 2, 10),
    ('Lara', 'Croft', 'lara.c@manor.uk', 'Active', 8, 5),
    ('Geralt', 'Rivia', 'geralt.r@kaermorhen.pl', 'Active', 9, 6),
    ('Kratos', 'Sparta', 'kratos.s@olympus.gr', 'Cancelled', 9, 7),
    ('Aloy', 'Nora', 'aloy.n@horizon.ca', 'Active', 1, 11),
    ('Nathan', 'Drake', 'nathan.d@fortune.us', 'Active', 2, 3),
    ('Chloe', 'Frazer', 'chloe.f@treasure.in', 'Active', 4, 13),
    ('Joel', 'Miller', 'joel.m@fireflies.us', 'Suspended', 2, 8),
    ('Ellie', 'Williams', 'ellie.w@jackson.us', 'Active', 2, 8),
    ('Samus', 'Aran', 'samus.a@federation.jp', 'Active', 10, 1),
    ('Cloud', 'Strife', 'cloud.s@avalance.jp', 'Active', 10, 10);
GO

-- Promotions
INSERT INTO Reports.promotion (promotion_code, discount_value, start_date, end_date) 
VALUES
    ('B2SCHOOL', 15.00, '2026-08-15', '2026-09-15'),
    ('AUTUMN26', 20.00, '2026-09-22', '2026-12-21'),
    ('EASTER_DEAL', 25.00, '2026-04-03', '2026-04-06'),
    ('BOGO50', 50.00, '2026-01-01', '2026-12-31'),
    ('CYBER_MON', 45.00, '2026-11-30', '2026-11-30'),
    ('MAY_DAY', 10.00, '2026-05-01', '2026-05-01'),
    ('V_DAY26', 14.00, '2026-02-10', '2026-02-15'),
    ('CANADA_DAY', 30.00, '2026-07-01', '2026-07-01'),
    ('US_INDEPENDENCE', 17.76, '2026-07-04', '2026-07-04'),
    ('MEX_REVOLUTION', 20.00, '2026-11-20', '2026-11-20');
GO

-- Exchange Rates
INSERT INTO Reports.exchange_rate (from_currency, to_currency, rate) 
VALUES  
    ('AUD', 'CAD', 0.880000),
    ('KRW', 'CAD', 0.001000),
    ('ARS', 'CAD', 0.001500),
    ('COP', 'CAD', 0.000340),
    ('ZAR', 'CAD', 0.071000),
    ('EGP', 'CAD', 0.028000),
    ('TRY', 'CAD', 0.042000),
    ('CHF', 'CAD', 1.520000),
    ('SEK', 'CAD', 0.130000),
    ('NOK', 'CAD', 0.125000),
    ('PLN', 'CAD', 0.340000),
    ('THB', 'CAD', 0.037000),
    ('SGD', 'CAD', 1.010000),
    ('NZD', 'CAD', 0.810000),
    ('HKD', 'CAD', 0.170000);
GO


-- Order Info
INSERT INTO Reports.order_info (customer_id, order_date, country_id, total_amount, currency_code, promotion_id)  
VALUES 
    (1, '2026-04-01', 9, 1250.00, 'EUR', NULL),   
    (2, '2026-04-02', 2, 5500.00, 'USD', 4),      
    (3, '2026-04-03', 2, 850.00, 'USD', 9),
    (4, '2026-04-04', 10, 2100.00, 'JPY', 3),     
    (5, '2026-04-05', 2, 15000.00, 'USD', 8),   
    (6, '2026-04-06', 8, 95.00, 'GBP', NULL),
    (7, '2026-04-07', 9, 4500.00, 'EUR', NULL),  
    (8, '2026-04-08', 9, 3000.00, 'EUR', 10),    
    (9, '2026-04-09', 1, 400.00, 'CAD', 1),
    (10, '2026-04-10', 2, 2200.00, 'USD', 9),     
    (11, '2026-04-11', 4, 45.00, 'INR', NULL),
    (12, '2026-04-12', 2, 310.00, 'USD', 7),
    (13, '2026-04-13', 2, 1100.00, 'USD', NULL),  
    (14, '2026-04-14', 10, 75.00, 'JPY', 3),
    (15, '2026-04-15', 10, 12000.00, 'JPY', NULL); 
GO

-- Order Details
INSERT INTO Reports.order_details (order_id, unit_price, quantity) 
VALUES
    (1, 1250.00, 1),
    (2, 1100.00, 5),
    (3, 425.00, 2),
    (4, 700.00, 3),
    (5, 5000.00, 3),
    (6, 95.00, 1),
    (7, 1500.00, 3),
    (8, 1000.00, 3),
    (9, 200.00, 2),
    (10, 1100.00, 2),
    (11, 45.00, 1),
    (12, 155.00, 2),
    (13, 550.00, 2),
    (14, 75.00, 1),
    (15, 4000.00, 3);
GO


/*====================================================================
     5. PERFORMANCE OPTIMIZATION (Indexes)
====================================================================*/
-- Clustered Index on Order Info (customer/date for reporting efficiency)
CREATE CLUSTERED INDEX CIX_order_info_customer_date 
ON Reports.order_info (customer_id, order_date DESC);
GO

-- Filtered Index for High Value Orders
CREATE NONCLUSTERED INDEX idx_high_value_orders
ON Reports.order_info(order_id)
INCLUDE (customer_id, order_date, total_amount)
WHERE total_amount > 1000;
GO

-- Filtered Index for Active Promotions
CREATE NONCLUSTERED INDEX idx_order_info_active_filtered
ON Reports.order_info (customer_id, order_date)
INCLUDE (total_amount, currency_code, promotion_id)
WHERE promotion_id IS NOT NULL;
GO

/*====================================================================
     6. STORED PROCEDURES (Business Logic)
====================================================================*/
-- Apply Promotions
CREATE PROCEDURE Reports.sp_apply_seasonal_promotion
    @order_id INT,
    @promotion_code VARCHAR(20)
AS
BEGIN
    DECLARE @discount DECIMAL(5,2), @promo_id INT;

    SELECT @promo_id = promotion_id, @discount = discount_value 
    FROM Reports.promotion WHERE promotion_code = @promotion_code;

    IF @promo_id IS NOT NULL
    BEGIN
        UPDATE Reports.order_info 
        SET promotion_id = @promo_id, 
            total_amount = total_amount - (total_amount * (@discount / 100))
        WHERE order_id = @order_id;
        PRINT 'Promotion applied successfully.';
    END
    ELSE
        RAISERROR('Invalid Promotion Code.', 16, 1);
END;
GO

-- Update Exchange Rates
CREATE PROCEDURE Reports.sp_update_exchange_rate
    @currency CHAR(3),
    @new_rate DECIMAL(18,6)
AS
BEGIN
    UPDATE Reports.exchange_rate
    SET rate = @new_rate, effective_date = GETDATE()
    WHERE from_currency = @currency;
    
    IF @@ROWCOUNT = 0 PRINT 'Currency not found.';
    ELSE PRINT 'Rate updated for ' + @currency;
END;
GO

/*====================================================================
     7. VIEWS & SECURITY
====================================================================*/
CREATE VIEW Reports.v_customer_orders AS
SELECT c.first_name, c.last_name, oi.order_date, oi.total_amount
FROM Reports.customer c
JOIN Reports.order_info oi ON c.customer_id = oi.customer_id;
GO

CREATE VIEW Reports.v_executive_global_sales AS
SELECT o.order_id, c.first_name + ' ' + c.last_name AS customer_name,
       co.country_name, o.total_amount, (o.total_amount * er.rate) AS total_in_cad
FROM Reports.order_info o
JOIN Reports.customer c ON o.customer_id = c.customer_id
JOIN Reports.country co ON o.country_id = co.country_id
JOIN Reports.exchange_rate er ON o.currency_code = er.from_currency;
GO

IF DATABASE_PRINCIPAL_ID('FinanceRole') IS NULL CREATE ROLE FinanceRole;
IF DATABASE_PRINCIPAL_ID('MarketingRole') IS NULL CREATE ROLE MarketingRole;
IF DATABASE_PRINCIPAL_ID('ExecutiveRole') IS NULL CREATE ROLE ExecutiveRole;
IF DATABASE_PRINCIPAL_ID('TesterUser') IS NULL CREATE ROLE TesterUser;
GO

-- Finance: Full control over money and reporting
GRANT SELECT, INSERT, UPDATE ON Reports.exchange_rate TO FinanceRole;
GRANT EXECUTE ON Reports.sp_update_exchange_rate TO FinanceRole;
GRANT SELECT ON Reports.v_executive_global_sales TO FinanceRole;

-- Marketing: Can manage promotions and track order success
GRANT SELECT, INSERT, UPDATE ON Reports.promotion TO MarketingRole;
GRANT EXECUTE ON Reports.sp_apply_seasonal_promotion TO MarketingRole;
GRANT SELECT ON Reports.v_customer_orders TO MarketingRole;

-- Executive: Read-only access to everything in the Reports schema
GRANT SELECT ON Reports.v_executive_global_sales TO ExecutiveRole;
GRANT SELECT ON Reports.v_customer_orders TO ExecutiveRole;

-- Tester: Full read access to validate the whole system
GRANT SELECT ON SCHEMA::Reports TO TesterUser;
GO

PRINT 'MultimediaSolutions Overlay Applied Successfully.';