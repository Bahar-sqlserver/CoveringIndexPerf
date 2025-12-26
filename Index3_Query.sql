  DROP INDEX IF EXISTS IX_Balanced ON dbo.SalesOrders;
  GO

  CREATE NONCLUSTERED INDEX IX_Balanced
ON dbo.SalesOrders (CustomerID, OrderStatus)
INCLUDE (OrderDate, TotalAmount);

SELECT OrderDate, TotalAmount, ShipCountry
FROM dbo.SalesOrders
WHERE CustomerID = 128
AND OrderStatus = 'C';
GO
