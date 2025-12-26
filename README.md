SQL Server Indexing Trade-Offs: Covering Index vs Balanced Index
Overview
This project demonstrates the impact of SQL Server indexing strategies on query performance.
It uses a synthetic dataset of 500,000 SalesOrders records to evaluate how different indexing approaches affect read performance, write cost, and overall system efficiency.
The project is divided into four stages to show a progressive analysis:
Bad Index — Nonclustered on CustomerID only.
Wide Covering Index — Maximum read performance.
Write-heavy scenario — Observe impact of heavy writes on previous index.
Balanced Index — Optimized for both read and write.

Dataset
The SalesOrders table contains:
|   Column   |   |   Description  |
| CustomerID |   | 1,000 unique customers   |
|  OrderDate |   | Random dates within the last year  |
| OrderStatus|   | 20% 'C' (completed), 80% 'O' (open)|
| TotalAmount|   |  Random decimal amounts   |
| ShipCountry|   | USA, Germany, France, Canada  |
| CreatedAt  |   |DateTime for record creation   |


## Performance Analysis

A frequently used reporting query was tested on the SalesOrders table (500,000 rows).

### Initial Index (IX_Bad)
- Execution Time: 447 ms
- Logical Reads: 1,590
- Physical Reads: 0
- Execution Plan Observations: Key Lookup present, Nested Loops join used
- Key Lookups: High
Notes: Basic index, reduces some reads but still many Key Lookups.

  ![Execution Plan for IX_Bad](1.png)

### Optimized Index (IX_Optimized)
- Execution Time: 89 ms (effectively negligible)
- Logical Reads: 5
- Physical Reads: 0
- Execution Plan Observations: Key Lookup and Nested Loops eliminated

![Execution Plan for IX_Optimized](2.png)

### Write-heavy scenario — Observe impact of heavy writes on previous index.

Query Execution Metrics:
- Rows affected: 391,936
- Logical reads: 3,303
- Elapsed time: 956 ms

- Stage 4 — Balanced Index: Optimized for both read performance and minimal write overhead, production-ready strategy.

### Summary
- Logical reads reduced from 1,522 → 5 (~99.7% reduction)
- Execution plan cost drastically reduced
- Physical reads remained zero, showing minimal I/O overhead
- Index optimization effectively eliminated expensive operations
