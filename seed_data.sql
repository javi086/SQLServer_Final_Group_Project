/* =====================================================
   SEED DATA — Using professor's inserts as structure format
   ===================================================== */

/* =========================
   EMPLOYEE
   ========================= */
INSERT INTO Employee
(EmployeeId, FirstName, LastName, JobTitle, Department, ReportsTo,
 HireDate, EmploymentStatus, WorkEmail, WorkPhone, OfficeLocation, AccessRole)
VALUES
(1, 'Andrew', 'Adams', 'General Manager', 'Management', NULL,
 '2019-01-15', 'Active', 'andrew.adams@media.com', '555-0100', 'Toronto', 'Admin');

INSERT INTO Employee
(EmployeeId, FirstName, LastName, JobTitle, Department, ReportsTo,
 HireDate, EmploymentStatus, WorkEmail, WorkPhone, OfficeLocation, AccessRole)
VALUES
(2, 'Nancy', 'Edwards', 'Sales Manager', 'Sales', 1,
 '2020-03-10', 'Active', 'nancy.edwards@media.com', '555-0101', 'Toronto', 'Manager');

INSERT INTO Employee
(EmployeeId, FirstName, LastName, JobTitle, Department, ReportsTo,
 HireDate, EmploymentStatus, WorkEmail, WorkPhone, OfficeLocation, AccessRole)
VALUES
(3, 'Jane', 'Peacock', 'Support Rep', 'Support', 2,
 '2021-07-22', 'Active', 'jane.peacock@media.com', '555-0102', 'Toronto', 'Support');


/* =========================
   CUSTOMER
   ========================= */
INSERT INTO Customer
(CustomerId, FirstName, LastName, Email, PhoneNumber, DateOfBirth,
 Address, City, State, Country, PostalCode, AccountStatus, SupportRepId)
VALUES
(1, 'Luis', 'Goncalves', 'luis@email.com', '555-1000',
 '1985-05-05', '123 King St', 'Toronto', 'ON', 'Canada', 'M5H1A1', 'Active', 3);

INSERT INTO Customer
(CustomerId, FirstName, LastName, Email, PhoneNumber, DateOfBirth,
 Address, City, State, Country, PostalCode, AccountStatus, SupportRepId)
VALUES
(2, 'Leonie', 'Kohler', 'leonie@email.com', '555-1001',
 '1990-08-14', '55 Queen St', 'Toronto', 'ON', 'Canada', 'M5H2B2', 'Active', 3);

INSERT INTO Customer
(CustomerId, FirstName, LastName, Email, PhoneNumber, DateOfBirth,
 Address, City, State, Country, PostalCode, AccountStatus, SupportRepId)
VALUES
(3, 'Francois', 'Tremblay', 'francois@email.com', '555-1002',
 '1978-11-02', '789 Bloor St', 'Toronto', 'ON', 'Canada', 'M5H3C3', 'Suspended', 3);


/* =========================
   ORDER (Invoice equivalent)
   ========================= */
INSERT INTO dbo.[Order]
(OrderId, CustomerId, OrderDate, BillingAddress, BillingCity,
 BillingState, BillingCountry, BillingPostalCode, Total)
VALUES
(1, 1, '2026-01-15', '123 King St', 'Toronto', 'ON', 'Canada', 'M5H1A1', 19.99);

INSERT INTO dbo.[Order]
(OrderId, CustomerId, OrderDate, BillingAddress, BillingCity,
 BillingState, BillingCountry, BillingPostalCode, Total)
VALUES
(2, 2, '2026-02-01', '55 Queen St', 'Toronto', 'ON', 'Canada', 'M5H2B2', 9.99);

INSERT INTO dbo.[Order]
(OrderId, CustomerId, OrderDate, BillingAddress, BillingCity,
 BillingState, BillingCountry, BillingPostalCode, Total)
VALUES
(3, 1, '2026-02-15', '123 King St', 'Toronto', 'ON', 'Canada', 'M5H1A1', 29.99);


/* =========================
   ORDERDETAILS
   =========================
   NOTE:
   we need an album table first before we make order detail inserts 
   because the order detail has a FK to album (dbo.Album(AlbumID))
*/
-- INSERT INTO dbo.[OrderDetails]
-- (OrderDetailId, OrderId, TrackId, UnitPrice, Quantity)
-- VALUES (...);