-- ==============================================
-- 1. Dynamic Customer Retrieval Procedure
-- ==============================================
CREATE OR ALTER PROCEDURE sp_GetCustomersDynamic
    @p_city NVARCHAR(100) = NULL,
    @p_status NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX) = 'SELECT * FROM Customer WHERE 1=1';

    IF @p_city IS NOT NULL
        SET @sql += ' AND City = @city';

    IF @p_status IS NOT NULL
        SET @sql += ' AND AccountStatus = @status';

    EXEC sp_executesql @sql,
        N'@city NVARCHAR(100), @status NVARCHAR(50)',
        @city = @p_city,
        @status = @p_status;
END;
GO

-- Example call:
-- EXEC sp_GetCustomersDynamic 'Toronto', 'Active';

-- ==============================================
-- 2. Update Customer Status Dynamically
-- ==============================================
CREATE OR ALTER PROCEDURE sp_UpdateCustomerStatusDynamic
    @p_customerId INT,
    @p_newStatus NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX) = 'UPDATE Customer SET AccountStatus = @status WHERE CustomerId = @id';

    EXEC sp_executesql @sql,
        N'@status NVARCHAR(50), @id INT',
        @status = @p_newStatus,
        @id = @p_customerId;
END;
GO

-- Example call:
-- EXEC sp_UpdateCustomerStatusDynamic 1, 'Active';

-- ==============================================
-- 3. Display All Customers
-- ==============================================
CREATE OR ALTER PROCEDURE sp_DisplayCustomers
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FirstName NVARCHAR(100), @LastName NVARCHAR(100), @Email NVARCHAR(100), @AccountStatus NVARCHAR(50);

    DECLARE cust_cursor CURSOR FOR
        SELECT FirstName, LastName, Email, AccountStatus FROM Customer;

    OPEN cust_cursor;

    FETCH NEXT FROM cust_cursor INTO @FirstName, @LastName, @Email, @AccountStatus;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT @FirstName + ' ' + @LastName + ' | ' + @Email + ' | ' + @AccountStatus;
        FETCH NEXT FROM cust_cursor INTO @FirstName, @LastName, @Email, @AccountStatus;
    END

    CLOSE cust_cursor;
    DEALLOCATE cust_cursor;
END;
GO

-- ==============================================
-- 4. List Customers by Employee
-- ==============================================
CREATE OR ALTER PROCEDURE sp_CustomersByEmployee
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EmpId INT, @EmpF NVARCHAR(100), @EmpL NVARCHAR(100);
    DECLARE @CustF NVARCHAR(100), @CustL NVARCHAR(100);

    DECLARE emp_cursor CURSOR FOR
        SELECT EmployeeId, FirstName, LastName FROM Employee;

    OPEN emp_cursor;

    FETCH NEXT FROM emp_cursor INTO @EmpId, @EmpF, @EmpL;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Employee: ' + @EmpF + ' ' + @EmpL;

        DECLARE cust_cursor CURSOR FOR
            SELECT FirstName, LastName FROM Customer WHERE SupportRepId = @EmpId;

        OPEN cust_cursor;

        FETCH NEXT FROM cust_cursor INTO @CustF, @CustL;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            PRINT '   Customer: ' + @CustF + ' ' + @CustL;
            FETCH NEXT FROM cust_cursor INTO @CustF, @CustL;
        END

        CLOSE cust_cursor;
        DEALLOCATE cust_cursor;

        FETCH NEXT FROM emp_cursor INTO @EmpId, @EmpF, @EmpL;
    END

    CLOSE emp_cursor;
    DEALLOCATE emp_cursor;
END;
GO

-- ==============================================
-- 5. Suspend Inactive Customers
-- ==============================================
CREATE OR ALTER PROCEDURE sp_SuspendInactiveCustomers
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CustId INT;

    DECLARE cust_cursor CURSOR FOR
        SELECT CustomerId FROM Customer WHERE SupportRepId IS NULL;

    OPEN cust_cursor;

    FETCH NEXT FROM cust_cursor INTO @CustId;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE Customer
        SET AccountStatus = 'Suspended'
        WHERE CustomerId = @CustId;

        FETCH NEXT FROM cust_cursor INTO @CustId;
    END

    CLOSE cust_cursor;
    DEALLOCATE cust_cursor;
END;
GO
