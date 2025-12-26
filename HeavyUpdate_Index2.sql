-- Update batch of open orders to completed
UPDATE dbo.SalesOrders
SET OrderStatus = 'C'
WHERE OrderStatus = 'O'
  AND CreatedAt < DATEADD(DAY, -7, GETDATE());
  GO