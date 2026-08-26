---
name: observability
description: Design, implement, or review production observability using service-level objectives, metrics, logs, traces, profiles, correlation, dashboards, alerts, and diagnostic context. Apply when system behavior or reliability must be understood from telemetry; minimize sensitive data and cardinality.
---

# Observability

Make important user outcomes measurable and failures diagnosable without requiring a redeploy.

## Working method

1. Identify users, critical journeys, service boundaries, failure modes, and operational decisions.
2. Define service-level indicators from user-visible success, latency, freshness, correctness, or durability; set objectives only with product and operational agreement.
3. Inventory existing signal schemas, collectors, dashboards, retention, cost, and incident gaps.
4. Instrument boundary operations consistently and correlate signals through context propagation.
5. Build actionable alerts and diagnostic views, then test them during failures.
6. Measure overhead, volume, cardinality, and sensitive-data exposure.

## Guardrails

- Never record secrets, credentials, session tokens, raw authorization headers, or unnecessary personal data.
- Do not place unbounded values such as user IDs, request IDs, raw URLs, or error messages in metric labels.
- Do not use logs as a substitute for metrics at high-volume aggregate questions.
- Telemetry must not break the user operation when its backend is unavailable; use bounded buffering and failure isolation.
- Sampling must preserve errors and important rare paths according to policy; sampled traces cannot prove exact totals.

## Signals

**Metrics** answer aggregate rate, error, duration, and saturation questions. Use counters for monotonic events, gauges for current state, and histograms for distributions. Choose buckets/views appropriate to objectives and control attributes deliberately.

**Logs** describe discrete events. Emit structured fields with stable event names, severity, service/version/environment, correlation IDs, outcome, and safe diagnostic context. Log exceptions once at the boundary that can act on them; avoid duplicate stack traces through every layer.

**Traces** show causal request paths. Create spans at meaningful service, queue, database, and external boundaries; propagate context across async work; record outcome and bounded semantic attributes. Avoid a span per trivial function.

**Profiles** locate resource-consuming code when runtime and maturity allow. Treat profiling data as potentially sensitive and manage overhead and retention.

## SLOs, dashboards, and alerts

Measure SLIs at the closest reliable point to user experience. Define good and total events precisely, including exclusions. Use error budgets to inform reliability decisions, not to hide individual customer impact.

Dashboards should move from service outcome to dependency and resource cause. Show rate, errors, latency distributions, saturation, deployments, and comparisons to normal baselines. Preserve units and avoid misleading averages.

Alert on symptoms that require timely action. Every page needs an owner, severity, actionable description, linked runbook, and deduplication/grouping. Use multi-window burn-rate or similarly robust detection where SLOs exist. Route non-urgent conditions to tickets or dashboards.

## Correlation, cost, and resilience

Use consistent semantic conventions and resource identity. Correlate logs with trace/span IDs and deployment version. Baggage crosses trust boundaries: allowlist it, limit size, and never propagate secrets.

Set retention, sampling, aggregation, and attribute policies by investigative value and cost. Test collector backpressure, exporter failure, queue saturation, and application overhead. Ensure clocks are synchronized enough for cross-system diagnosis.

## Verification and output

Exercise known success, client error, server error, timeout, cancellation, retry, and dependency failure. Verify dashboards receive expected data, alerts fire and resolve, trace propagation crosses boundaries, sensitive fields are absent, and cardinality stays bounded.

Report user outcomes and SLIs, signal schema, context propagation, dashboards/alerts/runbooks, privacy and cardinality controls, sampling/retention, failure behavior, tests performed, estimated overhead, and known blind spots.
