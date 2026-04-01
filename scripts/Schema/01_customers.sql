

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