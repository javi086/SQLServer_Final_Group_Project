CREATE TABLE OrderDetails
(
    OrderDetailId INT NOT NULL PRIMARY KEY CLUSTERED, 
    OrderId INT NOT NULL,                                                         
    UnitPrice DECIMAL(10,2) NOT NULL,                
    Quantity INT NOT NULL,                            
    CONSTRAINT FK_OrderDetails_Order FOREIGN KEY (OrderId)
        REFERENCES [Order](OrderId)
);
GO