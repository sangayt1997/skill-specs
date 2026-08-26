---
name: sql
description: Write, modify, debug, or review secure, correct, maintainable SQL and transactional behavior for the repository's actual database engine. Apply when SQL statements, joins, aggregation, data modification, locking, or isolation are central; verify dialect and version semantics.
---

# SQL

Make data semantics evident in the statement and enforce safety at the database boundary.

## Working method

1. Identify the engine/version, schema, constraints, data shape, expected result, access path, transaction boundary, and existing style.
2. State edge semantics: duplicates, nulls, ordering, timezone, collation, concurrent changes, and empty input.
3. Write explicit set-based SQL with bind parameters and qualified columns.
4. Inspect the plan for important queries and test representative and adversarial cases.
5. For mutations, validate affected rows, atomicity, retry behavior, and recovery before execution.

## Safety and correctness

- Bind data values through the driver. Never concatenate untrusted input into SQL.
- Parameters cannot safely stand in for identifiers or keywords; map dynamic identifiers and sort choices through a strict allowlist.
- Use a least-privilege database identity and preserve tenant and authorization predicates.
- Never execute destructive or production SQL without explicit authorization, exact target verification, and an appropriate recovery plan.
- Avoid `SELECT *` in stable application contracts and joins; make schema dependencies visible.

## Relational semantics

Choose joins from required cardinality and missing-row behavior. Confirm that join keys are unique where one-to-one or many-to-one behavior is assumed. Prevent accidental many-to-many multiplication before aggregating. Use `EXISTS` for existence checks when it expresses intent better than a join, and `NOT EXISTS` for anti-joins where `NOT IN` plus `NULL` would be ambiguous.

Remember SQL uses three-valued logic. Compare nulls with dialect-supported null predicates, not ordinary equality. Define whether null sorts first or last rather than relying on a dialect default. Use `IS DISTINCT FROM` or an equivalent only after confirming support.

Aggregation changes row grain: state the output grain, group every nonaggregated dependency as required by the dialect, and distinguish `COUNT(*)` from `COUNT(nullable_column)`. Use window functions when retaining row detail; define deterministic partitioning and ordering.

Without `ORDER BY`, row order is unspecified. Pagination ordering must be total and stable, usually including a unique tie-breaker. Treat collation, case folding, and timezone conversion as business semantics.

## Data modification

Scope updates and deletes with precise predicates and verify expected cardinality. Prefer constraints and atomic conditional statements over read-then-write checks. Use upsert/merge only after understanding the engine's conflict target, trigger behavior, concurrency semantics, and returned-row behavior.

For bulk work, batch by stable keys and account for locks, log growth, replicas, cancellation, and retries. Do not assume a transaction makes an external API or message publish atomic; use an outbox or equivalent pattern where needed.

## Transactions and concurrency

Set the transaction boundary around a business invariant, not arbitrary repository calls. Know the engine's default isolation and the anomalies it permits. Use row locks, optimistic versions, unique constraints, or serializable transactions according to the conflict being prevented.

Keep transactions short, acquire locks in consistent order, and do not hold them across user interaction or slow network calls. Deadlocks and serialization failures may be expected; retry the entire transaction only when operations are idempotent and attempts are bounded.

## Maintainability and performance

Use CTEs, derived tables, or views to clarify distinct logical stages, while checking version-specific materialization behavior. Comment the reason for non-obvious constructs, not syntax. Prefer engine-supported, portable constructs when portability is required; otherwise use the chosen dialect explicitly.

Inspect plans for high-impact statements using realistic bind values and data. An index is not a substitute for correct predicates and cardinality. Measure round trips and transferred rows from the application as well as server execution.

## Verification and output

Test empty sets, nulls, duplicates, boundary values, time zones, large cardinalities, concurrent conflicts, authorization isolation, and rollback. For mutations, verify both selected and excluded rows.

Report the intended result and row grain, engine/version assumptions, transaction and isolation behavior, security controls, expected cardinality, plan evidence where relevant, tests performed, and any operational prerequisites.
