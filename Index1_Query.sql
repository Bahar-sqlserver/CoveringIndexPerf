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
