---
name: algorithmic-efficiency
description: Prevent avoidable algorithmic, computational, database, network, and scalability problems during code implementation, modification, refactoring, and review. Apply across frontend and backend projects while keeping analysis proportional and avoiding premature optimization.
---

# Algorithmic Efficiency

Build the simplest correct, maintainable solution that fits the expected workload. Apply this guardrail across frontend and backend code, databases, APIs, workers, batch jobs, CLIs, and libraries. Follow the project's stack and architecture; do not add dependencies or layers solely for theoretical gains.

## Working Method

Before changing a scale-sensitive path:

1. Establish expected input/output sizes, growth, distribution, frequency, and resource limits. Infer from project evidence; ask only when the answer would change the design.
2. Identify the algorithm, data structures, database operations, network calls, and allocations involved.
3. Determine relevant time and space complexity. Define variables, for example `n = users` and `m = orders`.
4. Look for repeated work, unfavorable growth, excessive allocation, N+1 access, unnecessary round trips, or unbounded work.
5. Compare reasonable alternatives across correctness, memory, latency, readability, and maintenance; implement the least complicated option suitable for realistic scale.
6. Verify that the change introduced no meaningful complexity or scalability regression.

Keep this reasoning lightweight and internal unless reporting is warranted.

## Non-Negotiable Guardrails

- **MUST** preserve correctness, security, ordering, duplicates, consistency, transactions, and error semantics.
- **MUST** investigate accidental `O(n^2)`, `O(n^3)`, exponential behavior, N+1 queries, repeated remote calls, unbounded concurrency, and unbounded memory when realistic inputs make them significant.
- **MUST** compare relevant before-and-after characteristics when changing algorithms, traversal, query or I/O patterns, or execution order. Justify material regressions.
- **MUST NOT** infer `O(n^2)` merely from nested syntax. Determine whether loops use the same input, independent inputs, shrinking ranges, fixed bounds, or disjoint collections.
- **MUST NOT** claim practical speedups from Big-O alone when constants, latency, allocation, serialization, I/O, or runtime overhead may dominate.
- **MUST NOT** introduce unlimited parallelism, caching without a validity and memory-bound strategy, or indexes without considering write and storage costs.
- **SHOULD** prefer straightforward code for small, fixed, or tightly bounded inputs when sophistication adds no meaningful value.
- **SHOULD** use project evidence, profiling, query plans, or representative benchmarks when alternatives have similar complexity.
- **MAY** accept higher complexity for correctness, business behavior, architectural consistency, or clarity on genuinely bounded inputs; explain the reason when material.

## Algorithms and Data Structures

Check important paths for repeated searching, filtering, sorting, transformation, recomputation, copying, or materialization. Examine nested iteration and recursion with excessive depth, duplicated subproblems, or exponential branching.

Choose arrays/lists, sets, maps, queues, stacks, heaps, trees, graphs, or indexes according to ordering, duplicates, access patterns, memory, traversal, and worst-case risk.

Example: repeated membership tests against a growing list inside another loop may justify building a set once, changing expected time from `O(n x m)` to `O(n + m)` with `O(m)` extra space. Keep the list when inputs are tiny or when ordering, duplicates, or hashing behavior make the set unsuitable.

## Databases and Remote I/O

Treat database and network operations as part of the cost model, not as constant-time details.

For database work, check:

- query count, N+1 access, and queries inside loops;
- selected columns and rows, joins, repeated queries, and application-side filtering or aggregation;
- pagination, deterministic ordering, and sensible result limits;
- access patterns that may benefit from an index;
- round trips, rows scanned or transferred, oversized transactions, buffering, and materialization.

Use query plans and production-like measurements before confident claims. Evaluate index selectivity and write/storage costs. Large offsets may still compute or skip preceding rows; prefer cursor/keyset pagination when behavior and indexing support it. Do not replace N+1 access blindly with one giant join: weigh round trips against duplicated rows, cartesian expansion, memory, and consistency.

For other I/O, check looped or duplicate requests, avoidable sequencing, oversized payloads, and missing batching, pagination, streaming, chunking, or backpressure.

Run independent operations concurrently only when semantics allow. Bound concurrency by downstream and local limits; preserve rate limits, cancellation, timeouts, ordering, and partial-failure handling. Retries require duplicate safety, capped attempts and duration, and suitable backoff and jitter.

## Frontend and Backend Focus

On frontends, examine render-time transformations, derived-state work, redundant requests, allocations, DOM growth, large collections, and long main-thread tasks. Consider pagination or virtualization for large lists. Consider chunking, scheduling, or workers for substantial CPU work after accounting for coordination and serialization costs. Memoize only costly work with correct dependency semantics.

On backends, examine request-path algorithms, repeated queries, blocking or sequential I/O, payload size, memory growth, batch processing, and work that scales with total data rather than the requested partition.

For large or unbounded datasets, consider pagination, batching, streaming, incremental processing, backpressure, or external-memory techniques instead of loading everything at once.

Cache only significant repeated work with defined keys, ownership, invalidation/expiry, memory bounds, consistency, failure behavior, and observability.

## Accurate Complexity Claims

Define every variable and analyze actual input relationships:

- separate passes over `n` users and `m` orders: `O(n + m)`;
- comparing every user with every order: `O(n x m)`;
- triangular traversal of one growing input: `O(n^2)`;
- a fixed product or protocol bound: `O(1)` relative to growing input, although its constant cost may matter.

Account for preprocessing, sorting, hashing, recursion, output size, remote operations, and memory. Include output-sensitive cost for `k` results. Distinguish expected, amortized, and worst-case bounds when relevant.

## Validation and Reporting

Big-O does not capture latency, disk I/O, allocation pressure, cache behavior, serialization, concurrency limits, runtime behavior, user responsiveness, or framework overhead.

When performance matters, benchmark or profile representative workloads. Inspect query plans, counts, rows scanned/transferred, and round trips. Test boundaries, memory, pagination, batching, streaming, and concurrency. For frontends, measure responsiveness and main-thread work. Add focused regression tests only when worth maintaining.

Do not invent measurements or present an unmeasured constant-factor improvement as fact.

Report only meaningful optimizations or regressions, material scalability effects, architectural trade-offs, or explicit user requests:

```text
Performance:
- Before: O(n^2)
- After: O(n)
- Space: O(n)
- Reason: Replaced repeated linear membership searches with a hash lookup.
- Trade-off: Retains an additional lookup structure.
```

Include variable definitions, workload assumptions, and uncertainty when needed for accuracy.
