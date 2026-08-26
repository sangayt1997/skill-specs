---
name: database-design
description: Design or review durable relational and non-relational data models with explicit invariants, keys, relationships, constraints, lifecycle, tenancy, and evolution paths. Apply when creating or materially changing persisted schemas; use query-performance or migrations guidance for primarily diagnostic or rollout work.
---

# Database Design

Design persistence around domain truth, expected access, and safe evolution—not around a convenient object graph alone.

## Working method

1. Discover the authoritative concepts, invariants, ownership boundaries, lifecycle, access patterns, volume, retention, and compliance needs.
2. Inspect the actual engine, version, schema conventions, migration tooling, and deployed compatibility window.
3. Model logical entities and relationships before selecting physical types, partitions, or indexes.
4. Encode invariants at the strongest practical layer, preferably with database constraints.
5. Validate representative reads, writes, concurrency conflicts, deletion, recovery, and evolution.
6. Document decisions that future migrations or consumers must preserve.

## Guardrails

- Preserve existing data and public contracts. A schema task does not authorize destructive migration or production execution.
- Never rely only on application validation for uniqueness, referential integrity, or other cross-request invariants.
- Do not denormalize without a measured access need, refresh strategy, consistency owner, and repair path.
- Do not store secrets, regulated data, or tenant identifiers without classification and access controls.
- Treat engine-specific types and behavior as versioned choices; verify them in authoritative documentation.

## Model domain truth

Give each table or collection a clear purpose and owner. Use stable identifiers independent of mutable display data. Define natural-key uniqueness even when a surrogate primary key is used. Represent many-to-many relationships explicitly when the relationship has attributes or lifecycle.

Normalize to remove update anomalies and duplicated facts. Deliberately denormalize only when the cost and consistency model are understood. Avoid polymorphic foreign keys that the database cannot validate unless the project has a compelling, documented pattern.

For every attribute decide:

- meaning, unit, valid range, nullability, and default semantics;
- canonical representation, collation, and case behavior;
- whether absence differs from empty, zero, or unknown;
- creation, update, expiry, deletion, and audit requirements.

Use exact numeric types for money and other exact quantities; store currency or unit explicitly. Use timezone-aware instants for events and separate local civil time plus zone when recurrence depends on local rules. Do not use floating point for exact equality or financial amounts.

## Constraints and integrity

Use primary keys, unique constraints, foreign keys, checks, exclusion constraints, and generated values where supported. Understand the engine's `NULL` and deferred-constraint semantics. Name important constraints predictably so errors and migrations are diagnosable.

Choose referential actions intentionally:

- restrict deletion when dependents must be handled explicitly;
- cascade only when child ownership and blast radius are clear;
- set null only when orphaned state is meaningful and permitted.

Soft deletion is a product and retention policy, not a universal default. If used, specify uniqueness among live rows, cascade behavior, restore conflicts, purge, and query filtering. Preserve immutable audit evidence separately from mutable business rows when required.

## Scale, tenancy, and lifecycle

Estimate row width, growth, write rate, hot keys, working set, and cardinality. Partition only for a demonstrated operational or access need; define partition pruning, uniqueness limitations, maintenance, and archival. Avoid premature sharding. If sharding is needed, choose a key that balances locality, distribution, resharding, and tenant isolation.

For multi-tenant data, make the tenant boundary explicit in keys, foreign keys, uniqueness, authorization filters, backups, and erasure. Database row policies can add defense in depth but do not replace application authorization or connection-context safety.

Define retention, legal hold, export, anonymization, deletion, backup, and restoration expectations. Check that backups include schema objects and that restore exercises validate actual integrity.

## Physical design and evolution

Derive indexes from verified access patterns after logical correctness. Account for write amplification, lock behavior, storage, and maintenance. Separate immutable event history from current projections when their workloads conflict, but define rebuilding and ordering semantics.

Design changes for mixed application versions. Prefer additive, expand-and-contract evolution; avoid reusing removed columns with new meaning. Record compatibility assumptions and migration sequencing.

## Verification and output

Test constraint violations, concurrent writes, boundary values, tenant isolation, cascades, restore behavior, and representative query plans with realistic cardinality. Review generated ORM schema and SQL rather than assuming mappings are equivalent.

Report the data model, invariants and where they are enforced, keys and relationships, lifecycle and tenancy rules, expected scale, engine-specific assumptions, evolution approach, verification, and unresolved trade-offs.
