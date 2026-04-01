

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