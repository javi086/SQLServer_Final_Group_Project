CREATE TABLE Order_Details (
    OrderDetailId INT IDENTITY(1,1), 
    OrderId INT NOT NULL,                                                         
    UnitPrice DECIMAL(10,2) NOT NULL,                
    Quantity INT NOT NULL,                            

    CONSTRAINT PK_OrderDetails PRIMARY KEY CLUSTERED (OrderDetailId),
    CONSTRAINT FK_OrderDetails_Order FOREIGN KEY (OrderId) REFERENCES Order_Info (OrderId),
    CONSTRAINT CK_OrderDetails_Quantity CHECK (Quantity > 0)
);
GO