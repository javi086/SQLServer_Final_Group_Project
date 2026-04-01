

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