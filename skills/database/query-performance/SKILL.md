---
name: query-performance
description: Diagnose and improve database query performance using workload evidence, execution plans, cardinality, I/O, round trips, contention, and application-level access patterns. Apply to slow, expensive, or scaling queries; preserve semantics and verify improvements under representative load.
---

# Query Performance

Improve the user-visible workload, not an isolated query benchmark.

## Diagnose before changing

1. Define the affected operation and latency/error objective.
2. Capture normalized statements, frequency, p50/p95/p99 duration, rows, I/O, CPU, waits, locks, and representative parameters.
3. Trace application work to reveal N+1 access, repeated queries, connection waits, serialization, and network transfer.
4. Inspect schema, statistics, indexes, engine/version, data distribution, and the actual execution plan safely.
5. Form a falsifiable bottleneck hypothesis and change one material factor at a time.
6. Compare before/after behavior under production-shaped load and concurrency.

## Guardrails

- Preserve result semantics, ordering, isolation, authorization, and tenant filters.
- Do not run execution-analyzing tools that execute writes against valuable data.
- Do not optimize from a single literal, cold development database, or planner cost alone.
- Do not hide a systemic problem behind aggressive caching without freshness and invalidation semantics.
- Parameterize untrusted values; optimization never justifies SQL injection risk.

## Application access patterns

Eliminate N+1 queries through set-oriented retrieval, safe eager loading, batching, or data loaders while controlling row multiplication. Select only needed columns and rows. Paginate large results with stable deterministic ordering; prefer keyset/seek pagination for deep, frequently traversed datasets when its navigation trade-offs fit.

Reduce round trips, but do not create one enormous join that multiplies entities, spills memory, and transfers duplicates. Compare joined retrieval, multiple bounded queries, aggregation, and precomputation against actual data shape. Stream large results only when connection occupancy, cancellation, and backpressure are handled.

## Read execution plans

Interpret plan shape together with actual row counts and loops. Investigate:

- estimate-to-actual cardinality errors and skew;
- full scans that examine far more rows than returned;
- inefficient join order or algorithm;
- repeated inner operations;
- sorts, hashes, or aggregations spilling to disk;
- random lookups and excessive heap/table fetches;
- filters applied after large intermediate results;
- lock, I/O, CPU, memory, or connection-pool waits.

Sequential scans are not inherently wrong, and index scans are not inherently fast. Judge by table size, selectivity, cache state, and total cost. Refresh or improve statistics only with an understanding of sampling, correlation, and operational overhead.

## Corrective options

Choose among query reformulation, appropriate indexing, better predicates/types, eliminating implicit casts, batching, schema correction, materialized summaries, partition pruning, or workload scheduling. Verify optimizer behavior for the exact engine and version. Avoid hints unless there is strong evidence and a plan for data evolution.

Keep transactions short but semantically complete. Diagnose lock contention and hot rows before tuning SQL text. When replicas serve reads, define acceptable lag and read-after-write behavior.

## Verification and regression control

Use representative cardinality, skew, concurrency, and parameter distributions. Measure end-to-end latency plus database time, rows examined, logical/physical I/O, CPU, memory/spills, locks, connections, and write effects. Check plan stability across common and worst-case parameters.

Add a regression benchmark or query budget only when stable enough to be useful. Observe after release and define rollback thresholds. Report the evidence, root cause, semantic constraints, chosen change, before/after measures, plan differences, operational effects, and remaining risk.
