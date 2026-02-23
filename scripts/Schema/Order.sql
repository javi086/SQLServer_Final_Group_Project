CREATE TABLE dbo.[Order]
(
    OrderId INT NOT NULL PRIMARY KEY CLUSTERED,      -- maps from InvoiceId
    CustomerId INT NOT NULL,                          -- maps from CustomerId
    OrderDate DATETIME NOT NULL,                      -- maps from InvoiceDate
    BillingAddress NVARCHAR(70),                      -- maps from BillingAddress
    BillingCity NVARCHAR(40),                         -- maps from BillingCity
    BillingState NVARCHAR(40),                        -- maps from BillingState
    BillingCountry NVARCHAR(40),                      -- maps from BillingCountry
    BillingPostalCode NVARCHAR(10),                  -- maps from BillingPostalCode
    Total DECIMAL(10,2),                              -- maps from Total
    CONSTRAINT FK_Order_Customer FOREIGN KEY (CustomerId)
        REFERENCES dbo.Customer(CustomerId)
);
GO