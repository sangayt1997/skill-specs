---
name: migrations
description: Plan, implement, validate, or review production database schema and data migrations with mixed-version compatibility, bounded locking, resumable backfills, verification, and recovery. Apply when persisted data or schema must evolve across deployments; never execute against production without explicit authorization.
---

# Migrations

Evolve persisted data without relying on an instant, perfectly ordered deployment.

## Working method

1. Inventory engine/version, data size and skew, traffic, replicas, migration framework, deployed application versions, and recovery objectives.
2. Classify the change by compatibility, locking, rewrite, validation, backfill, and irreversibility risk.
3. Consult authoritative engine documentation and test the generated SQL—not only ORM declarations.
4. Design an expand–migrate–contract sequence that tolerates rolling deploys and rollback.
5. Rehearse on production-shaped data, observe locks and duration, and define stop criteria.
6. Execute only in the environment explicitly authorized; verify every phase before contraction.

## Guardrails

- Never assume a DDL statement is metadata-only, transactional, online, or reversible across engines or versions.
- Do not combine a large backfill and blocking schema change in one opaque transaction.
- Do not drop or narrow data while any live code, rollback target, report, replica, or integration still needs it.
- A down migration is not recovery when it would discard transformed data. Prefer forward repair or restore/replay planning.
- Use bounded batches, checkpoints, idempotency, and throttling for data movement.

## Expand–migrate–contract

**Expand:** add compatible structures and indexes, usually nullable or with semantics that do not require an immediate table-wide rewrite. Deploy code that can tolerate old and new forms. If dual writing, define source of truth, atomicity, retries, and reconciliation.

**Migrate:** backfill in bounded deterministic batches. Use stable keys, checkpoint progress, handle concurrent changes, and make reruns safe. Measure replication lag, lock waits, database load, error rate, and application latency. Validate counts, constraints, samples, checksums, or domain invariants.

**Contract:** switch reads to the new representation, stop old writes, observe through the rollback window, validate again, then remove old structures in a separate deliberate release.

Avoid indefinite dual writes: they create two sources of truth and complicated failure modes. Prefer transactional writes where possible, or use an outbox/change stream plus reconciliation when boundaries differ.

## Analyze operational risk

For each statement determine lock mode and duration, table rewrite or scan, transaction-log growth, temporary and final disk use, replica behavior, connection impact, and cancellation semantics. Set lock/statement timeouts where supported and define abort thresholds before starting.

Adding a constraint may be separated into creation and later validation on engines that support it. Adding an index may have an online/concurrent form with special restrictions and cleanup needs. Adding a non-null/default column varies significantly by engine version; verify actual behavior.

## Data backfills

- Select batches by stable indexed ranges rather than offset pagination.
- Commit batches independently and persist progress outside process memory.
- Make the transformation deterministic and safe to retry.
- Prevent an old batch from overwriting newer user changes with version checks or conditional updates.
- Throttle by measured system health, not a fixed delay alone.
- Quarantine and report malformed rows; do not silently coerce important data.
- Run reconciliation until no drift remains before cutover.

## Rollout, recovery, and verification

Specify prerequisites, exact ordering, owner, maintenance constraints, observability, pause/resume, rollback point, and post-deploy validation. Backups help only if recoverability and restore time are tested; identify point-in-time recovery and replay consequences.

Test fresh install, upgrade from every supported predecessor, partial execution, rerun, rollback-compatible application behavior, replica lag, and representative query plans. Confirm migration metadata records success only after work is actually complete.

Report the phase plan, compatibility matrix, generated SQL, lock/rewrite analysis, data and time estimates, backfill controls, validation evidence, stop conditions, recovery path, and irreversible decisions.
