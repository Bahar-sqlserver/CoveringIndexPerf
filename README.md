# CoveringIndexPerf
Showcasing SQL Server covering indexes to boost query performance.

This project demonstrates the effect of Covering Indexes in SQL Server to improve query performance by eliminating Key Lookups.

## Performance Analysis

A frequently used reporting query was tested on the SalesOrders table (500,000 rows).

### Initial Index (IX_Bad)
- Execution Time: 447 ms
- Logical Reads: 1,590
- Physical Reads: 0
- Execution Plan Observations: Key Lookup present, Nested Loops join used

### Optimized Index (IX_Optimized)
- Execution Time: 0 ms (effectively negligible)
- Logical Reads: 5
- Physical Reads: 0
- Execution Plan Observations: Key Lookup and Nested Loops eliminated

### Summary
- Logical reads reduced from 1,522 → 5 (~99.7% reduction)
- Execution plan cost drastically reduced
- Physical reads remained zero, showing minimal I/O overhead
- Index optimization effectively eliminated expensive operations
