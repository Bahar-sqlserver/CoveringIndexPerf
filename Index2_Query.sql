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
