---
name: indexing
description: Design, diagnose, or review database indexes from measured query plans, predicates, ordering, selectivity, cardinality, and write cost. Apply when access paths or index maintenance affect database performance; do not add speculative indexes without workload evidence.
---

# Indexing

Create the smallest evidence-backed index set that serves important workloads without unacceptable write, storage, or maintenance cost.

## Workflow

1. Capture the exact slow or important statements, bind-value distributions, frequency, latency, rows examined/returned, and concurrency.
2. Identify the engine and version; inspect table statistics, size, existing indexes, constraints, and write rate.
3. Read the actual execution plan, preferably with runtime measurements in a safe representative environment.
4. Explain why the current access path is costly before proposing an index.
5. compare candidate indexes against query benefit, write amplification, cache use, build risk, and redundancy.
6. Validate plans and workload metrics, then define rollback and post-release observation.

## Guardrails

- Never run plan modes that execute mutating SQL against valuable data merely to inspect it.
- Do not force an index or disable planner strategies until statistics, estimates, and alternatives are understood.
- Do not assume development-scale plans represent production cardinality or skew.
- Verify online/concurrent build syntax, transaction restrictions, lock behavior, disk headroom, and failure cleanup for the exact engine version.
- An index that supports a constraint is not redundant merely because another index shares a prefix.

## Match the access pattern

Map equality predicates, ranges, joins, ordering, grouping, and selected columns to the engine's index rules. For B-tree-style composite indexes, leading columns and the transition from equality to range commonly determine efficient navigation; verify rather than applying folklore. Consider how sort direction, null ordering, collation, expressions, and operator classes affect eligibility.

Use purpose-built types where appropriate:

- unique indexes or constraints for uniqueness;
- partial or filtered indexes for stable selective predicates;
- expression/function indexes for matching normalized expressions;
- covering/include columns to reduce lookups when the engine can perform index-only access;
- full-text, spatial, inverted, or block-range indexes for their supported operators and distributions.

The query expression and predicate must match what the optimizer can prove. Parameterization, implicit casts, functions on indexed columns, collation differences, and type mismatches can make a plausible index unusable.

## Cost and selectivity

Estimate selectivity by realistic value distribution, not distinct-count averages alone. Account for skew, correlated columns, hot tenants, and stale statistics. A low-selectivity index may still help a covering query, ordered limit, or selective partial predicate; a high-selectivity index may still lose when the query returns much of the table.

Every additional index consumes storage and cache, increases insert/update/delete work, can amplify WAL or replication traffic, and needs vacuum/rebuild/compaction work. Wide keys and included columns magnify these costs. Remove redundancy only after proving no constraint, query, or operational tool depends on it.

## Plans and validation

Read estimates and actuals separately: access method, join order and algorithm, scan and returned rows, filter losses, loops, sorts/spills, heap/table lookups, buffers/I/O, memory, and timing. Large estimate errors usually call for statistics or model investigation before index proliferation.

Test with representative volume, skew, warm and cold cache where relevant, and concurrent writes. Compare p50/p95/p99 query latency, CPU, logical/physical reads, lock time, index size, and write throughput. Ensure the index is used for intended queries without regressing more important ones.

## Delivery

Provide the observed plan and bottleneck, proposed index definition, queries it supports, predicted and measured benefit, write/storage/build cost, engine/version assumptions, rollout and rollback method, and monitoring window. State when no new index is the best result.
