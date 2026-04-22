/*====================================================================
  COURSE: SQL Server Development
  DELIVERABLE: Final Project for SQL Developer Course
  DATABASE: MultimediaSolutions
  STUDENT:Jose Javier Santana Vera
====================================================================*/


CREATE TABLE Reports.promotion (
    promotion_id        INT IDENTITY(1,1),
    promotion_code      VARCHAR(20) NOT NULL,
    discount_value      DECIMAL(5,2) NOT NULL,
    start_date          DATE NOT NULL,
    end_date            DATE NULL,

    CONSTRAINT PK_Reports_promotion             PRIMARY KEY CLUSTERED (promotion_id),
    CONSTRAINT UQ_Reports_promotion_code        UNIQUE (promotion_code),
    CONSTRAINT CK_Reports_promotion_value       CHECK (discount_value <= 50.00),
    CONSTRAINT CK_Reports_promotion_dates       CHECK (end_date IS NULL OR end_date >= start_date)
);
GO