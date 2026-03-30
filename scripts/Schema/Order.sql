CREATE TABLE Order
(
    OrderId INT NOT NULL PRIMARY KEY CLUSTERED,      
    CustomerId INT NOT NULL,                         
    OrderDate DATETIME NOT NULL,                      
    BillingAddress NVARCHAR(70),                      
    BillingCity NVARCHAR(40),                       
    BillingState NVARCHAR(40),                       
    BillingCountry NVARCHAR(40),                      
    BillingPostalCode NVARCHAR(10),                  
    Total DECIMAL(10,2),                              
    CONSTRAINT FK_Order_Customer FOREIGN KEY (CustomerId)
        REFERENCES Customer(CustomerId)
);
GO