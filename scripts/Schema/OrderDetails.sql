CREATE TABLE dbo.[OrderDetails]
(
    OrderDetailId INT NOT NULL PRIMARY KEY CLUSTERED, -- maps from InvoiceLineId
    OrderId INT NOT NULL,                             -- maps from InvoiceId
    TrackId INT NOT NULL,                             -- maps from TrackId
    UnitPrice DECIMAL(10,2) NOT NULL,                -- maps from UnitPrice
    Quantity INT NOT NULL,                            -- maps from Quantity
    CONSTRAINT FK_OrderDetails_Order FOREIGN KEY (OrderId)
        REFERENCES dbo.[Order](OrderId),
    CONSTRAINT FK_OrderDetails_Track FOREIGN KEY (TrackId)
        REFERENCES dbo.Album(AlbumId)                -- or Track table if exists
);
GO