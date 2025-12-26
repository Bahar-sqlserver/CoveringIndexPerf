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

