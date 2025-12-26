UPDATE dbo.SalesOrders
SET OrderStatus = 'C'
WHERE OrderStatus = 'O'
  AND CreatedAt < DATEADD(DAY, -7, GETDATE());
  GO

