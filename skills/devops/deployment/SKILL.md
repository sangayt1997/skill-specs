---
name: deployment
description: Plan, automate, execute, or review safe repeatable application deployments with immutable artifacts, compatibility, progressive exposure, health verification, rollback or roll-forward, and auditability. Apply to release changes; external deployment requires explicit target authorization.
---

# Deployment

Release a known artifact while limiting blast radius and preserving a credible recovery path.

## Before deployment

1. Identify exact artifact digest, target environment, owner, approval, maintenance constraints, dependencies, and success criteria.
2. Compare application, configuration, infrastructure, database, queue/event, and client compatibility across old and new versions.
3. Classify irreversible changes and choose rollback, roll-forward, backup/restore, or feature-disable recovery.
4. Verify capacity, quotas, credentials, health probes, observability, alerts, and on-call readiness.
5. Define rollout increments, observation windows, abort thresholds, and communication.

## Guardrails

- Never deploy, scale, change traffic, or mutate a shared environment without explicit authorization for that target.
- Promote the tested immutable artifact; do not rebuild or patch it manually in production.
- Do not use process liveness alone as readiness or business health.
- Do not combine unrelated risky changes when independent rollback is valuable.
- Never claim rollback is safe if schema, data, events, or external effects are backward-incompatible.
- Keep secrets out of images, manifests, source, logs, and command output.

## Compatibility

Support the overlap created by rolling deployments: old and new instances, in-flight requests, cached data, queued messages, and asynchronous workers may coexist. Make APIs and events additive before removal. Use expand–migrate–contract for persisted data. Ensure consumers tolerate unknown optional fields and producers do not emit a new requirement before consumers are ready.

Configuration changes are versioned releases. Validate required keys and formats before traffic; provide safe defaults only where semantically correct. Separate deployment from feature exposure when flags materially reduce risk, and define flag ownership and cleanup.

## Rollout strategy

Choose recreate, rolling, blue/green, canary, or feature-based exposure from statefulness, capacity, cost, and risk. Progressive delivery needs representative cohorts, stable comparison, adequate sample size, and automatic or human stop criteria—not just small traffic.

Readiness should reflect ability to serve. Startup probes protect slow initialization; liveness should detect unrecoverable process failure without causing restart loops. Graceful termination must stop admission, drain in-flight work within a deadline, and release leases or connections.

## Observe and decide

Monitor user-facing success, error rate, latency, saturation, queue lag, resource pressure, dependency failures, and business correctness against a baseline. Account for telemetry delay. Use deployment markers and correlate artifact/config version in signals.

Pause or abort on predefined thresholds. Avoid repeatedly restarting a bad rollout. If rollback is unsafe, halt exposure and execute the prepared roll-forward or feature-disable plan.

## Recovery and verification

Rollback must identify the exact prior artifact and compatible configuration. Test recovery procedures before relying on them. Backups are useful only with verified restoration and acceptable recovery time/data loss.

After rollout, run smoke and synthetic checks, validate critical data paths, confirm all intended instances and migrations, monitor through the agreed window, and retain audit evidence. Clean obsolete resources only after recovery windows expire.

Report artifact and target, authorization, compatibility analysis, strategy and increments, health signals and thresholds, result, rollback/roll-forward readiness, configuration/database changes, and follow-up observations.
