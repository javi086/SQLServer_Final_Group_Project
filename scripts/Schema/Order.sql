CREATE TABLE Order_Info (
    OrderId INT IDENTITY(1,1),      
    CustomerId INT NOT NULL,                         
    OrderDate DATETIME NOT NULL,                      
    BillingAddress NVARCHAR(70),                      
    BillingCity NVARCHAR(40),                       
    CountryId INT NOT NULL,                      
    Total DECIMAL(10,2) NOT NULL,
    CurrencyCode CHAR(3) NOT NULL,
    PromotionId INT NULL,

    CONSTRAINT PK_Order PRIMARY KEY CLUSTERED (OrderId),
    CONSTRAINT FK_Order_Customer FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId),
    CONSTRAINT FK_Order_Country FOREIGN KEY (CountryId) REFERENCES Country(CountryId),
    CONSTRAINT FK_Order_Promotion FOREIGN KEY (PromotionId) REFERENCES Promotion(PromotionId)
);
GO