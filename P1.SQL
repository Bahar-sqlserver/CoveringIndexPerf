-- Step 1: Drop database if exists and create new one
DROP DATABASE IF EXISTS IndexLab;
GO
CREATE DATABASE  IndexLab;
GO
-- Step 2: Use the new database
USE INDEXLAB;
GO
-- Step 3: Drop table if exists
DROP TABLE IF EXISTS dbo.SalesOrders;
GO
-- Step 4: Create SalesOrders table
CREATE TABLE dbo.SalesOrders (
OrderID INT IDENTITY PRIMARY KEY,
CustomerID INT,
OrderDate DATE,
OrderStatus CHAR(1),
TotalAmount DECIMAL(10,2),
ShipCountry NVARCHAR(50),
CreatedAt DATETIME
);
GO

-- Step 5: Insert sample data
;WITH N AS (
    SELECT TOP (500000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM master..spt_values a
    CROSS JOIN master..spt_values b
)
INSERT INTO dbo.SalesOrders (CustomerID, OrderDate, OrderStatus, TotalAmount, ShipCountry, CreatedAt)
SELECT
    ABS(CHECKSUM(NEWID())) % 1000 + 1,
    DATEADD(DAY, -n % 365, GETDATE()),
    CASE WHEN n % 5 = 0 THEN 'C' ELSE 'O' END,
    ABS(CHECKSUM(NEWID())) % 10000 / 1.0,
    CASE n % 4
        WHEN 0 THEN 'USA'
        WHEN 1 THEN 'Germany'
        WHEN 2 THEN 'France'
        ELSE 'Canada'
    END,
    DATEADD(MINUTE, -n, GETDATE())
FROM N;
GO

-- Step 6: Count rows
SELECT COUNT(*) FROM dbo.SalesOrders;

-- Step 7: Create initial nonclustered index (IX_Bad)
DROP INDEX IF EXISTS IX_Bad ON dbo.SalesOrders;
GO

CREATE NONCLUSTERED INDEX IX_Bad
ON dbo.SalesOrders (CustomerID);
GO

-- Step 8: Test query before optimized index
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO
SELECT OrderDate, TotalAmount, ShipCountry
FROM dbo.SalesOrders
WHERE CustomerID = 128
AND OrderStatus = 'C';
GO
-- Step 9: Create covering index 
DROP INDEX IF EXISTS IX_Customer_Status_Cover ON dbo.SalesOrders;
GO

CREATE NONCLUSTERED INDEX IX_Customer_Status_Cover
ON dbo.SalesOrders (CustomerID, OrderStatus)
INCLUDE (OrderDate, TotalAmount, ShipCountry);
GO
-- Step 10: Test query after optimized index
SELECT OrderDate, TotalAmount, ShipCountry
FROM dbo.SalesOrders
WHERE CustomerID = 128
AND OrderStatus = 'C';
GO


SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

