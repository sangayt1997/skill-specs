---
name: integration-testing
description: Create, improve, or review integration tests across real module, framework, database, broker, filesystem, or service boundaries. Apply when correctness depends on wiring or dependency semantics that unit doubles cannot prove; keep environments isolated, reproducible, and bounded.
---

# Integration Testing

Verify the smallest real integration that could fail because components disagree.

## Working method

1. Name the boundary and incompatibility risk: schema, protocol, transaction, serialization, configuration, lifecycle, or failure behavior.
2. Select the smallest topology that includes the real semantics needed for evidence.
3. Pin dependency versions and provision isolated infrastructure reproducibly.
4. Create independent scenario data, exercise through a public entry point, and assert durable outcomes plus important effects.
5. Test representative failures and cleanup.
6. Run in CI with useful artifacts and ownership.

## Guardrails

- Do not call production or a shared mutable environment by default.
- Do not replace the dependency behavior under test with a mock and still label the result integration evidence.
- Avoid in-memory substitutes when transaction, query, filesystem, broker, or wire semantics differ materially.
- Never depend on test order or leftover state. Parallel workers need distinct resources or namespaces.
- Keep credentials scoped to disposable resources and redact them from logs and artifacts.

## Choose fidelity intentionally

Use real databases for SQL, constraints, migrations, isolation, and driver behavior. Use a real broker for acknowledgements, ordering, redelivery, and serialization. Use an HTTP stub server for owned client behavior when the remote service cannot be safely provisioned, and pair it with schema/contract verification where compatibility matters.

Containers or ephemeral services improve reproducibility but are not inherently representative: pin versions, wait on readiness rather than port-open alone, apply the real migrations/configuration, and capture startup logs. Test every supported dependency version only when the compatibility claim requires it.

## State and lifecycle

Give each test unique tenant, account, topic, bucket, schema, or identifier space. Prefer creating known state over relying on a preloaded mystery dataset. Cleanup is defense in depth; isolation must prevent collisions even if a prior run crashes before cleanup.

Decide whether transaction rollback is valid. It is unsuitable when committed visibility, multiple connections, asynchronous consumers, or database transaction behavior is under test. Reset through disposable resources, truncation, or namespace deletion when those semantics matter.

## Assert contracts and failures

Assert observable results at both sides of the boundary: response plus stored state, published event plus outbox record, file output plus metadata. Cover encoding, nulls, timezones, precision, large values, retries, duplicate delivery, timeouts, partial failure, and version skew according to risk.

For async systems, wait on observable conditions with a bounded deadline; never sleep and hope. Make at-least-once assumptions explicit and verify idempotency where required. Contract tests should validate consumer/provider assumptions but do not replace selected real integration paths.

## CI diagnostics

Balance startup and fixture reuse against isolation. Reuse immutable infrastructure per worker when safe, but never share mutable scenario state. Capture dependency logs, application logs, request/trace IDs, schema version, image versions, and failure artifacts. Fail fast on readiness and configuration errors.

## Completion report

Report the boundary and risk proven, real components and substituted components, version/configuration, isolation and cleanup model, scenarios including failures, commands/results, CI cost, diagnostics, and limitations that still require end-to-end or production validation.
