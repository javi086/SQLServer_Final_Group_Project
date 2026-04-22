

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
    CONSTRAINT FK_Reports_order_info_promotion       FOREIGN KEY (promotion_id) REFERENCES Reports.promotion(promotion_id),
    CONSTRAINT CK_Reports_order_info_total_amount    CHECK (total_amount > 0),
    CONSTRAINT CK_Reports_order_info_order_date      CHECK (order_date <= GETDATE())
);
GO