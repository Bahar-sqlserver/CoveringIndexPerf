SQL Server Indexing Trade-Offs: Covering Index vs Balanced Index
Overview
This project demonstrates the impact of SQL Server indexing strategies on query performance.
It uses a synthetic dataset of 500,000 SalesOrders records to evaluate how different indexing approaches affect read performance, write cost, and overall system efficiency.
The project is divided into four stages to show a progressive analysis:
Bad Index — Nonclustered on CustomerID only.
Wide Covering Index — Maximum read performance.
Write-heavy scenario — Observe impact of heavy writes on previous index.
Balanced Index — Optimized for both read and write.

[table](table.sql)


## Performance Analysis

A frequently used reporting query was tested on the SalesOrders table (500,000 rows).

[Bad index](Index1_Query.sql)
### Initial Index (IX_Bad)
- Execution Time: 532 ms
- Logical Reads: 1,703
- Physical Reads: 0
- Execution Plan Observations: Key Lookup present, Nested Loops join used
- Key Lookups: High
Notes: Basic index, reduces some reads but still many Key Lookups.

  ![Execution Plan for IX_Bad](1.png)
  [real_exec](plan1.sqlplan)


### Optimized Index 
[covering_index_Optimized](Index2_Query.sql)
- Execution Time: 387 ms 
- Logical Reads: 4
- Physical Reads: 0
- Execution Plan Observations: Key Lookup and Nested Loops eliminated

![Execution Plan for IX_Optimized](2.png)
[real_exec](plan2.sqlplan)

[Write-heavy scenario](HeavyUpdate_Index2.sql)
Observe impact of heavy writes on previous index.

Query Execution Metrics:
- Rows affected: 391,936
- Logical reads: 2,483,151
- Elapsed time: 7,781 ms
- ![exec](exec_hvy2)
- [real_exec](ExecPlan_Stage3_WriteHeavy.sqlplan)

- Stage 4 — Balanced Index: Optimized for both read performance and minimal write overhead
[ready strategy](Index3_Query.sql).
- Execution Time: 434 ms (effectively negligible)
- Logical Reads: 340
- Physical Reads: 0
- Execution Plan Observations: Index scan. Key Lookup and Nested Loops eliminated
[exec](exec_balanced.png)



- [real_exec](execu_balanced_write.sqlplan)

- ### Write-heavy scenario — Observe impact of heavy writes on balanced index.
- [Write_strategy](Index3_HeavyUpdate.sql)

- Query Execution Metrics:
- Rows affected: 391,936
- Logical reads: 2,372,593
- Elapsed time: 5,899 ms
- ![exec](exec_balanced_hvy.png)
  - [real_exec](exec_balanced_hvy.sqlplan)

### Summary

