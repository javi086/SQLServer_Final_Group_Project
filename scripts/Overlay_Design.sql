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
     PRE-FLIGHT CHECKS
====================================================================*/
IF DB_ID(N'MultimediaSolutions') IS NULL
BEGIN
    RAISERROR('MultimediaSolutions database not found. Install/restore MultimediaSolutions before running.', 16, 1);
    RETURN;
END
GO


/*====================================================================
     SCHEMA
====================================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'Reports')
BEGIN
    EXEC(N'CREATE SCHEMA Reports AUTHORIZATION dbo;');
END
GO



/*====================================================================
     CLEANUP - Drop existing Sim objects  (safe reset for reruns)

  This section will contain the reports that we are going to generate.
====================================================================*/
-- Procedures


-- Views


-- Tables (child first)


IF OBJECT_ID(N'Reports.order_details', N'U') IS NOT NULL DROP TABLE Reports.order_details;
GO
IF OBJECT_ID(N'Reports.order_info', N'U') IS NOT NULL DROP TABLE Reports.order_info;
GO
IF OBJECT_ID(N'Reports.customer', N'U') IS NOT NULL DROP TABLE Reports.customer;
GO
IF OBJECT_ID(N'Reports.employee', N'U') IS NOT NULL DROP TABLE Reports.employee;
GO

-- Parents tables (No Dependencies)
IF OBJECT_ID(N'Reports.country', N'U') IS NOT NULL DROP TABLE Reports.country;
GO
IF OBJECT_ID(N'Reports.promotion', N'U') IS NOT NULL DROP TABLE Reports.promotion;
GO
IF OBJECT_ID(N'Reports.exchange_rate', N'U') IS NOT NULL DROP TABLE Reports.exchange_rate;
GO



/*====================================================================
     CREATION OF PARENT TABLES (other tables reference them)
====================================================================*/

CREATE TABLE Reports.country (
    country_id          INT IDENTITY(1,1),
    country_name        VARCHAR(50) NOT NULL,
    country_code        CHAR(3) NOT NULL,
    currency_code       CHAR(3) NOT NULL,

    CONSTRAINT PK_Reports_country             PRIMARY KEY CLUSTERED (country_id),
    CONSTRAINT UQ_Reports_country_name        UNIQUE (country_name),
    CONSTRAINT UQ_Reports_country_code        UNIQUE (country_code)
);
GO

CREATE TABLE Reports.promotion (
    promotion_id        INT IDENTITY(1,1),
    promotion_code      VARCHAR(20) NOT NULL,
    discount_value      DECIMAL(5,2) NOT NULL,
    start_date          DATE NOT NULL,
    end_date            DATE NULL,

    CONSTRAINT PK_Reports_promotion             PRIMARY KEY CLUSTERED (promotion_id),
    CONSTRAINT UQ_Reports_promotion_code        UNIQUE (promotion_code),
    CONSTRAINT CK_Reports_promotion_value       CHECK (discount_value <= 50.00)
);
GO

CREATE TABLE Reports.exchange_rate (
    exchange_rate_id    INT IDENTITY(1,1),
    from_currency       CHAR(3) NOT NULL,
    to_currency         CHAR(3) DEFAULT 'CAD',
    rate                DECIMAL(18,6) NOT NULL,
    effective_date      DATETIME DEFAULT GETDATE(),

    CONSTRAINT PK_Reports_exchange_rate        PRIMARY KEY CLUSTERED (exchange_rate_id)
);
GO



CREATE TABLE Reports.employee (
    employee_id         INT IDENTITY(1,1),
    first_name          VARCHAR(50) NOT NULL,
    last_name           VARCHAR(50) NOT NULL,
    job_title           VARCHAR(100) NOT NULL,
    department          VARCHAR(100) NOT NULL,
    reports_to          INT NULL,
    hire_date           DATE NOT NULL,
    employment_status   VARCHAR(20) NOT NULL,
    work_email          VARCHAR(100) NOT NULL,
    country_id          INT NOT NULL,

    CONSTRAINT PK_Reports_employee             PRIMARY KEY CLUSTERED (employee_id),
    CONSTRAINT UQ_Reports_employee_email       UNIQUE (work_email),
    CONSTRAINT FK_Reports_employee_manager     FOREIGN KEY (reports_to) REFERENCES Reports.employee(employee_id),
    CONSTRAINT FK_Reports_employee_country     FOREIGN KEY (country_id) REFERENCES Reports.country(country_id),
    CONSTRAINT CK_Reports_employee_status      CHECK (employment_status IN ('Active', 'Inactive'))
);
GO

CREATE TABLE Reports.customer (
    customer_id         INT IDENTITY(1,1),
    first_name          VARCHAR(50) NOT NULL,
    last_name           VARCHAR(50) NOT NULL,
    email               VARCHAR(100) NOT NULL,
    phone_number        VARCHAR(20),
    date_of_birth       DATE,
    address             VARCHAR(150),
    city                VARCHAR(50),
    state               VARCHAR(50),
    country_id          INT NOT NULL,
    postal_code         VARCHAR(20),
    account_status      VARCHAR(20) NOT NULL,
    support_rep_id      INT,

    CONSTRAINT PK_Reports_customer              PRIMARY KEY CLUSTERED (customer_id),
    CONSTRAINT UQ_Reports_customer_email        UNIQUE (email),
    CONSTRAINT FK_Reports_customer_country      FOREIGN KEY (country_id) REFERENCES Reports.country(country_id),
    CONSTRAINT FK_Reports_customer_support_rep  FOREIGN KEY (support_rep_id) REFERENCES Reports.employee(employee_id),
    CONSTRAINT CK_Reports_customer_status       CHECK (account_status IN ('Active', 'Suspended', 'Cancelled'))
);
GO



CREATE TABLE Reports.order_info (
    order_id            INT IDENTITY(1,1),      
    customer_id         INT NOT NULL,                         
    order_date          DATETIME NOT NULL,                      
    billing_address     NVARCHAR(70),                      
    billing_city        NVARCHAR(40),                       
    country_id          INT NOT NULL,                      
    total_amount        DECIMAL(10,2) NOT NULL,
    currency_code       CHAR(3) NOT NULL,
    promotion_id        INT NULL,

    CONSTRAINT PK_Reports_order_info                 PRIMARY KEY CLUSTERED (order_id),
    CONSTRAINT FK_Reports_order_info_customer        FOREIGN KEY (customer_id) REFERENCES Reports.customer(customer_id),
    CONSTRAINT FK_Reports_order_info_country         FOREIGN KEY (country_id) REFERENCES Reports.country(country_id),
    CONSTRAINT FK_Reports_order_info_promotion       FOREIGN KEY (promotion_id) REFERENCES Reports.promotion(promotion_id)
);
GO

CREATE TABLE Reports.order_details (
    order_detail_id     INT IDENTITY(1,1), 
    order_id            INT NOT NULL,                                                         
    unit_price          DECIMAL(10,2) NOT NULL,                
    quantity            INT NOT NULL,                            

    CONSTRAINT PK_Reports_order_details              PRIMARY KEY CLUSTERED (order_detail_id),
    CONSTRAINT FK_Reports_order_details_order        FOREIGN KEY (order_id) REFERENCES Reports.order_info(order_id),
    CONSTRAINT CK_Reports_order_details_quantity     CHECK (quantity > 0)
);
GO


/*--------------------------------------
            Creation of Child tables
---------------------------------------*/









/*====================================================================
     INSERTS
====================================================================*/

-- Country

INSERT INTO Reports.country (country_name, country_code, currency_code) 
VALUES
        ('Canada', 'CAN', 'CAD'),
        ('United States', 'USA', 'USD'),
        ('Mexico', 'MEX', 'MXN'),
        ('India', 'IND', 'INR'),
        ('Russia', 'RUS', 'RUB'),
        ('China', 'CHN', 'CNY'),
        ('Brazil', 'BRA', 'BRL'),
        ('United Kingdom', 'GBR', 'GBP'),
        ('Germany', 'DEU', 'EUR'),
        ('Japan', 'JPN', 'JPY');

-- Promotion

INSERT INTO Reports.promotion (promotion_code, discount_value, start_date, end_date) 
VALUES
        ('WELCOME10', 10.00, '2026-01-01', '2026-12-31'),
        ('MEX_IND_DAY', 20.00, '2026-09-15', '2026-09-17'),
        ('BLACKFRIDAY', 50.00, '2026-11-25', '2026-11-30'),
        ('HOLIDAY25', 25.00, '2026-12-01', '2026-12-26'),
        ('SPRING2026', 15.00, '2026-03-20', '2026-06-20'),
        ('DIWALI_DEAL', 30.00, '2026-10-25', '2026-11-05'),
        ('SUMMER_HITS', 10.00, '2026-06-01', '2026-08-31'),
        ('NY_CELEBRATION', 40.00, '2026-12-30', '2027-01-05'),
        ('LOVAL_USER', 5.00, '2026-01-01', NULL),
        ('EXPANSION_SALE', 35.00, '2026-04-01', '2026-04-30');

-- Employee

INSERT INTO Reports.employee (first_name, last_name, job_title, department, reports_to, hire_date, employment_status, work_email, country_id) 
VALUES
        ('Javi', 'Admin', 'Chief Technology Officer', 'Executive', NULL, '2025-01-10', 'Active', 'javi.admin@multimedia.ca', 1),
        ('Alice', 'Smith', 'Marketing Manager', 'Marketing', 1, '2025-02-15', 'Active', 'alice.s@multimedia.ca', 1),
        ('Roberto', 'Gomez', 'Sales Lead', 'Sales', 1, '2025-03-01', 'Active', 'roberto.g@multimedia.mx', 3),
        ('Ananya', 'Iyer', 'Data Analyst', 'Finance', 1, '2025-05-20', 'Active', 'ananya.i@multimedia.in', 4),
        ('Chen', 'Wei', 'Regional Manager', 'Operations', 1, '2025-06-10', 'Active', 'chen.w@multimedia.cn', 6),
        ('Elena', 'Petrova', 'Support Specialist', 'Customer Success', 3, '2025-08-12', 'Active', 'elena.p@multimedia.ru', 5),
        ('John', 'Doe', 'Accountant', 'Finance', 4, '2025-09-01', 'Active', 'john.d@multimedia.ca', 1),
        ('Maria', 'Silva', 'Sales Rep', 'Sales', 3, '2025-10-05', 'Active', 'maria.s@multimedia.mx', 3),
        ('Liam', 'Wilson', 'Marketing Specialist', 'Marketing', 2, '2025-11-20', 'Active', 'liam.w@multimedia.ca', 2),
        ('Yuki', 'Tanaka', 'IT Support', 'IT', 1, '2026-01-05', 'Active', 'yuki.t@multimedia.jp', 10);

-- Customer

INSERT INTO Reports.customer (first_name, last_name, email, country_id, account_status, support_rep_id) 
VALUES
        ('Carlos', 'Santana', 'carlos.s@gmail.com', 3, 'Active', 8),
        ('Priya', 'Sharma', 'priya.sharma@yahoo.in', 4, 'Active', 6),
        ('James', 'Bond', 'j.bond@mi6.uk', 8, 'Active', 3),
        ('Igor', 'Ivanov', 'igor.i@mail.ru', 5, 'Suspended', 6),
        ('Mei', 'Lin', 'mei.lin@wechat.cn', 6, 'Active', 5),
        ('Robert', 'Miller', 'bob.m@outlook.com', 2, 'Active', 9),
        ('Fatima', 'Oliveira', 'fatima.o@uol.com.br', 7, 'Active', 3),
        ('Hans', 'Müller', 'hans.m@t-online.de', 9, 'Cancelled', 8),
        ('Sarah', 'Conner', 's.conner@skynet.ca', 1, 'Active', 7),
        ('Kenji', 'Sato', 'kenji.s@docomo.jp', 10, 'Active', 10);


-- Exchange 

INSERT INTO Reports.exchange_rate (from_currency, to_currency, rate) 
VALUES  
        ('USD', 'CAD', 1.350000),
        ('MXN', 'CAD', 0.081000),
        ('INR', 'CAD', 0.016000),
        ('RUB', 'CAD', 0.014000),
        ('CNY', 'CAD', 0.190000),
        ('BRL', 'CAD', 0.270000),
        ('GBP', 'CAD', 1.710000),
        ('EUR', 'CAD', 1.460000),
        ('JPY', 'CAD', 0.009000),
        ('CAD', 'CAD', 1.000000);

-- Order info

INSERT INTO Reports.order_info (customer_id, order_date, country_id, total_amount, currency_code, promotion_id) 
VALUES 
        (1, '2026-03-01', 3, 500.00, 'MXN', 2),
        (2, '2026-03-02', 4, 1200.00, 'INR', 6),
        (3, '2026-03-05', 8, 45.00, 'GBP', NULL),
        (5, '2026-03-10', 6, 300.00, 'CNY', 10),
        (6, '2026-03-12', 2, 89.99, 'USD', 1),
        (7, '2026-03-15', 7, 150.00, 'BRL', 9),
        (9, '2026-03-18', 1, 120.00, 'CAD', NULL),
        (10, '2026-03-20', 10, 5000.00, 'JPY', 1),
        (1, '2026-03-22', 3, 250.00, 'MXN', NULL),
        (2, '2026-03-25', 4, 800.00, 'INR', 10);

-- Order details

INSERT INTO Reports.order_details (order_id, unit_price, quantity) 
VALUES
        (1, 250.00, 2),
        (2, 400.00, 3),
        (3, 45.00, 1),
        (4, 150.00, 2),
        (5, 89.99, 1),
        (6, 75.00, 2),
        (7, 60.00, 2),
        (8, 2500.00, 2),
        (9, 125.00, 2),
        (10, 800.00, 1);



/*====================================================================
     INDEXES (business-aligned access patterns)
====================================================================*/





/*====================================================================
     PROCEDURES
====================================================================*/



/*====================================================================
        VIEWS
====================================================================*/



/*====================================================================
         DEMO EXECUTION 
====================================================================*/


/*====================================================================
   VALIDATION QUERIES
====================================================================*/