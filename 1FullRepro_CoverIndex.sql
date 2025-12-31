DROP TABLE IF EXISTS dbo.SalesOrders;
GO
--Creating table
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

--inserting data in table
;WITH N AS (
    SELECT TOP (500000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM master.sys.all_objects a
    CROSS JOIN master.sys.all_objects b
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

-- Count rows
SELECT COUNT(*) FROM dbo.SalesOrders;

--  Create initial nonclustered index (IX_Bad)
DROP INDEX IF EXISTS IX_Bad ON dbo.SalesOrders;
GO

CREATE NONCLUSTERED INDEX IX_Bad
ON dbo.SalesOrders (CustomerID);
GO

-- Test query before optimized index
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO
SELECT OrderDate, TotalAmount, ShipCountry
FROM dbo.SalesOrders
WHERE CustomerID = 128
AND OrderStatus = 'C';
GO
-- Create covering index 
DROP INDEX IF EXISTS IX_Customer_Status_Cover ON dbo.SalesOrders;
GO

CREATE NONCLUSTERED INDEX IX_Customer_Status_Cover
ON dbo.SalesOrders (CustomerID, OrderStatus)
INCLUDE (OrderDate, TotalAmount, ShipCountry);
GO
-- Test query after optimized index
SELECT OrderDate, TotalAmount, ShipCountry
FROM dbo.SalesOrders
WHERE CustomerID = 128
AND OrderStatus = 'C';
GO


-- Test query after optimized index on heavy writes
UPDATE dbo.SalesOrders
SET OrderStatus = 'C'
WHERE OrderStatus = 'O'
  AND CreatedAt < DATEADD(DAY, -7, GETDATE());
  GO

  -- Create balanced index 
  DROP INDEX IF EXISTS IX_Balanced ON dbo.SalesOrders;
  GO

  CREATE NONCLUSTERED INDEX IX_Balanced
ON dbo.SalesOrders (CustomerID, OrderStatus)
INCLUDE (OrderDate, TotalAmount);
GO


-- Test query on heavy reads
SELECT OrderDate, TotalAmount, ShipCountry
FROM dbo.SalesOrders
WHERE CustomerID = 128
AND OrderStatus = 'C';
GO


-- Test query on heavy writes(balanced index)
UPDATE dbo.SalesOrders
SET OrderStatus = 'C'
WHERE OrderStatus = 'O'
  AND CreatedAt < DATEADD(DAY, -7, GETDATE());
  GO

  SET STATISTICS TIME,IO OFF;
GO
