---
name: system-design
description: Design or evaluate software systems from requirements through boundaries, data, interfaces, quality attributes, operations, and evolution. Apply when a change requires system-level structure or cross-cutting architectural decisions; use focused implementation skills when the problem is local to one component.
---

# System Design

Produce an evidence-based design that stakeholders can review, engineers can implement, and operators can run. Connect business outcomes and user journeys to explicit responsibilities, interfaces, state, deployment, failure behavior, and measurable quality goals.

Architecture is a set of consequential decisions and constraints, not a collection of fashionable technologies. Start with the simplest coherent system that meets the required planning horizon, and preserve options where uncertainty is expensive.

## Working Method

1. Establish problem, scope, stakeholders, current state, and decision deadline.
2. Separate functional requirements, quality-attribute scenarios, constraints, assumptions, and non-goals.
3. Quantify workload, data, SLOs, security and compliance needs, growth, and cost boundaries.
4. Model system context, trust boundaries, primary flows, and sources of truth.
5. Generate a small number of viable structures and compare them against prioritized scenarios.
6. Assign responsibilities, data ownership, interfaces, dependency direction, and deployment boundaries.
7. Design failure, recovery, security, observability, delivery, migration, and decommissioning behavior.
8. Validate high-risk assumptions with analysis, prototypes, tests, or operational evidence.
9. Record decisions, alternatives, risks, and review triggers at the level needed to implement.

Adapt the depth to consequence and reversibility. A small internal feature may need a short design note; a new platform, critical data path, or irreversible migration needs multiple views, quantified analysis, and stakeholder review.

## Non-Negotiable Guardrails

- **MUST** distinguish confirmed requirements from assumptions and design choices.
- **MUST** assign one authority for every durable fact and protected invariant.
- **MUST** make security, privacy, reliability, operability, and migration first-class design concerns.
- **MUST** explain material trade-offs and rejected alternatives, including doing nothing.
- **MUST** preserve existing behavior and compatibility unless an approved requirement changes them.
- **MUST NOT** select microservices, events, queues, caches, databases, regions, or vendors before identifying the requirement they satisfy.
- **MUST NOT** imply unauthorized infrastructure changes, data movement, external communication, or destructive migration.
- **MUST NOT** treat a diagram, framework checklist, or technology inventory as sufficient analysis.
- **SHOULD** make decisions reversible when uncertainty is high and the cost of optionality is reasonable.
- **SHOULD** reuse project conventions and proven platform capabilities unless evidence justifies divergence.

## Frame the Problem

Write a concise statement covering:

- the user or business outcome;
- current behavior and pain;
- what is inside and outside the system boundary;
- affected users, operators, maintainers, security, data, legal, and business stakeholders;
- deadline and planning horizon;
- known constraints; and
- how success and failure will be recognized.

Inspect the actual repository and operating environment before proposing a new architecture. Identify existing components, data stores, APIs, deployment topology, conventions, ownership, telemetry, and known incidents. Do not design a parallel platform because current capabilities were overlooked.

## Requirements and Non-Goals

Separate:

- **functional requirements**: observable capabilities and workflows;
- **quality attributes**: reliability, performance, security, modifiability, usability, interoperability, portability, cost, and sustainability;
- **constraints**: mandated technologies, regulation, residency, contracts, skills, dates, and budgets;
- **assumptions**: beliefs requiring evidence or a review trigger; and
- **non-goals**: deliberately excluded outcomes.

Make requirements testable. Replace “highly available,” “real time,” “secure,” and “scalable” with conditions and measures.

Express important quality attributes as scenarios:

```text
Given <environment>, when <source> produces <stimulus>,
the <affected system or component> responds with <observable behavior>
within <measurable response>.
```

Examples include a zone failure during peak load, a privileged access attempt, a tenfold data increase, a schema change with old clients active, or restoration from backup. Prioritize scenarios with stakeholders because optimizing every attribute equally is impossible.

## Workload, SLOs, and Constraints

Quantify request and job rates, concurrency, payloads, read/write mix, fan-out, geographic distribution, tenant skew, data volume and growth, retention, and bursts. Include background, migration, retry, failover, and recovery traffic.

Define user-centered service-level indicators and objectives for critical journeys. Specify availability, latency percentiles, correctness, durability, freshness, completion deadline, and recovery targets as relevant. Identify dependencies whose objectives must support the end-to-end target and define error-budget or risk policy where the organization uses one.

Record hard ceilings: budget, delivery time, team capacity, platform quotas, latency physics, external rate limits, licensing, residency, and compliance. A design outside these constraints is not an option.

## System Context and Boundaries

Start with a context view showing:

- people or roles using the system;
- the system being designed;
- external systems and data authorities;
- meaningful relationships, protocols, and direction; and
- trust, network, ownership, and regulatory boundaries.

Give every element a precise name and responsibility. Label arrows with intent and protocol rather than “data.” Distinguish current, proposed, and future state.

Zoom into deployable or executable units only when the view answers a decision. Show code-level components only for an area whose internal structure matters. Use dynamic views for complex workflows and deployment views for runtime placement and failure domains. A diagram must have a title, scope, legend where needed, and accompanying narrative; it is not the source of truth by itself.

## Responsibilities and Decomposition

Decompose around cohesive responsibilities, invariants, data ownership, change drivers, security boundaries, and operational needs.

For each component or subsystem state:

- responsibility and owner;
- public contract;
- state and invariants owned;
- allowed dependencies;
- deployment and lifecycle;
- expected load and critical resources;
- failure behavior; and
- observability and operational controls.

Prefer a modular monolith or existing deployment when independent scaling, release, ownership, security, or failure isolation does not justify a process boundary. Network boundaries add latency, partial failure, version skew, security surface, and operational load.

Keep dependency direction intentional and avoid cycles. If two proposed services require synchronous coordination for most operations or share direct writes to the same invariants, reconsider whether they are independent.

## Data Design and Ownership

Model durable information before choosing storage products.

Define:

- entities, identifiers, relationships, invariants, and lifecycle;
- authoritative owner and permitted writers;
- access patterns, query shapes, ordering, and atomicity needs;
- volume, growth, retention, classification, residency, and deletion;
- consistency and freshness per operation;
- indexes, derived views, caches, and their rebuild or reconciliation path;
- schema and contract evolution; and
- backup, restore, archive, and audit requirements.

Choose storage from these properties: consistency, transaction scope, access pattern, scale, latency, durability, recovery, operational maturity, and cost. Do not choose a database because its category is fashionable.

Minimize duplicate authorities. When copying data for reads or integration, define source, propagation, lag, conflict policy, reconciliation, and deletion propagation. Align transaction boundaries with invariants; where an invariant crosses authorities, make coordination and failure recovery explicit.

## Interfaces and Contracts

Design APIs, commands, events, files, schemas, and operator interfaces from consumer needs while protecting provider invariants.

For each contract define:

- identity, authentication, authorization, and tenant scope;
- request and response semantics;
- validation, size, rate, and concurrency limits;
- idempotency and duplicate behavior;
- timeout, retry, cancellation, and error semantics;
- consistency, ordering, pagination, and freshness;
- versioning, compatibility, deprecation, and ownership; and
- observability without leaking secrets or sensitive data.

Use synchronous calls when the caller needs an immediate outcome and latency/failure coupling is acceptable. Use asynchronous messaging when temporal decoupling, buffering, or independent processing is required and delayed or repeated delivery is handled correctly. Do not introduce an event bus merely to hide a direct dependency.

Keep protocols coarse enough to avoid chatty remote calls. Avoid exposing internal persistence records or vendor types as public contracts.

## Critical Flows

Trace end-to-end sequences for:

- primary success paths;
- authentication and authorization;
- writes and read-after-write behavior;
- asynchronous completion;
- retries and duplicate delivery;
- dependency timeout or unavailability;
- failover and recovery;
- deployment and rollback; and
- data migration and deletion.

At every step identify authority, state transition, deadline, possible partial result, and compensation or recovery. Validate that a caller's timeout exceeds the budget allocated across downstream work without encouraging runaway queues.

## Reliability and Failure Design

Start from the required SLO and failure domains. Enumerate failures of processes, nodes, zones, regions, networks, credentials, dependencies, configuration, deployment, data, capacity, and operators.

For each important failure specify:

- detection and user-visible impact;
- containment and blast radius;
- timeout, retry, fallback, or degraded mode;
- state safety and duplicate handling;
- failover and recovery authority;
- recovery time and data-loss bound; and
- validation method and runbook owner.

Use redundancy only across independent failure domains and test it. Bound retries with deadlines, backoff, jitter, and budgets. Add circuit breaking, bulkheads, load shedding, or queues only where the failure and recovery semantics are understood.

Backups are not a recovery design until restores are automated or rehearsed, integrity is checked, credentials and dependencies are available, and recovery objectives are demonstrated.

For consensus, replication, distributed transactions, clocks, or partitions, apply the distributed-systems skill rather than compressing those correctness decisions into a diagram.

## Security, Privacy, and Abuse Resistance

Threat-model the proposed system and significant changes.

- Identify assets, actors, entry points, trust boundaries, and abuse cases.
- Authenticate identities and authorize every protected action using least privilege.
- Separate control plane, data plane, and administrative access where risk warrants it.
- Encrypt sensitive data in transit and at rest with defined key ownership and rotation.
- Manage secrets outside source and logs; define issuance, rotation, revocation, and break-glass access.
- Validate untrusted input and bound expensive operations.
- Define audit events, tamper resistance, retention, and access.
- Minimize personal or regulated data and enforce purpose, consent, retention, export, and deletion requirements.
- Design tenant isolation across identity, compute, storage, cache, observability, and support tooling.

Consider supply-chain, dependency, configuration, insider, denial-of-service, and compromised-client threats. Document accepted risk and its authority; do not silently defer security as implementation detail.

## Performance and Scalability

Allocate latency and capacity budgets along critical paths. Identify resource demand, contention, fan-out, data access, caching opportunities, partition keys, and hard limits. Model skew and failure capacity, not only averages.

Define overload and backpressure before autoscaling. State how work is admitted, prioritized, queued, shed, degraded, or rejected while protecting downstream resources. For capacity models, partitioning, autoscaling, hotspots, load tests, and growth operations, apply the scalability skill.

## Operability and Observability

Design how the system will be understood and controlled in production.

Define:

- service and dependency health;
- SLI measurements and alert conditions;
- structured logs, metrics, traces, and correlation identifiers;
- dashboards by user journey, component, tenant, and failure domain as appropriate;
- safe configuration, feature flags, and runtime limits;
- runbooks for common failures and recovery;
- ownership, escalation, and support boundaries;
- audit and diagnostic access controls; and
- capacity, cost, security, and dependency review cadence.

Prefer alerts on actionable user impact or imminent exhaustion over raw resource noise. Ensure telemetry remains useful during overload and does not expose secrets, create unbounded cardinality, or become a failure amplifier.

## Delivery and Deployment

Specify build artifacts, environments, topology, configuration ownership, infrastructure dependencies, and release authority.

Design for:

- reproducible builds and immutable or traceable artifacts;
- automated policy and compatibility checks;
- progressive exposure where risk warrants it;
- health assessment and rollback or roll-forward criteria;
- backward and forward compatibility during mixed versions;
- safe database and message-schema evolution;
- secret and configuration changes independent of unsafe code assumptions; and
- environment parity proportional to risk.

Rollback is not always safe after data mutation or external side effects. For those changes, define expand/migrate/contract sequencing, reconciliation, and a forward repair path.

## Evolution and Migration

Describe current, transitional, and target states. Keep each transitional state deployable, observable, secure, and recoverable.

- Introduce compatibility before switching producers or consumers.
- Backfill with bounded load, checkpoints, verification, and restartability.
- Use shadow reads, dual reads, or dual writes only with a clear comparison and authority strategy.
- Move ownership once; avoid indefinite bidirectional synchronization.
- Define cutover gates, rollback limits, reconciliation, and stakeholder communication.
- Remove obsolete paths, flags, data, permissions, and infrastructure after verified exit criteria.

Strangler migrations can reduce cutover risk, but the routing layer and split ownership are real temporary complexity. Give every temporary mechanism an owner and removal condition.

## Cost and Sustainability

Estimate build, migration, steady-state, peak, recovery, support, and exit costs. Include network transfer, replicas, idle headroom, storage growth, observability, licensing, backups, and engineering operations.

Track useful work per unit cost and resource. Prefer demand-aligned resources, efficient algorithms and storage, data lifecycle controls, and managed capabilities when they reduce total risk and waste. Do not reduce resilience, security, or user outcomes solely to improve a single cost metric; expose the trade-off for decision.

## Compare Alternatives

Compare at least the current approach and viable alternatives against prioritized requirements. Use a compact matrix when helpful:

| Criterion | Weight or priority | Option A | Option B | Evidence or uncertainty |
| --- | --- | --- | --- | --- |
| Critical quality scenario | High | Response | Response | Test, model, incident, or assumption |

Consider simplicity, delivery time, correctness, reliability, security, performance, scalability, operability, modifiability, vendor dependence, cost, sustainability, and migration risk. Do not hide uncertainty in numeric scores; explain sensitivity to assumptions.

Identify:

- **risk points** where a requirement may not be met;
- **sensitivity points** where a small parameter or decision change has large effects;
- **trade-off points** where one quality improves while another worsens; and
- **unknowns** requiring a spike, benchmark, threat model, or stakeholder decision.

## Validate Before Commitment

Match validation to the risk:

- walk critical and failure scenarios through the design;
- prototype uncertain integrations or algorithms;
- benchmark performance and capacity assumptions;
- test data model and migrations at representative volume;
- perform threat modeling and targeted security tests;
- test contracts and compatibility across versions;
- rehearse deployment, failover, restore, and rollback or repair;
- use fault injection where safe; and
- review with implementers, operators, security, data owners, and affected business stakeholders.

Record test conditions and limitations. Passing a prototype proves only the conditions exercised.

## Architecture Documentation

Keep documentation near the system and version it when practical. Prefer a small set of maintained artifacts:

- problem statement, requirements, assumptions, and non-goals;
- context plus necessary structural, dynamic, data, and deployment views;
- interface and data contracts;
- SLOs, threat model, failure analysis, and operational model;
- migration plan; and
- architecture decision records for consequential choices.

An architecture decision record should include context, decision, status, alternatives, consequences, evidence, owner, date, and review trigger. Supersede decisions rather than rewriting history without trace.

Diagrams and prose must agree with implementation. Add automated checks for stable architectural constraints, and schedule review when reality cannot be derived automatically.

## Review Checklist

Before completing the design, verify:

- stakeholders agree on outcome, scope, priorities, and non-goals;
- assumptions are visible and high-risk ones are tested;
- every component and durable fact has clear ownership;
- critical flows, trust boundaries, and failure paths are represented;
- quality attributes have measurable scenarios or SLOs;
- compatibility, migration, rollback limits, and decommissioning are defined;
- security, privacy, operations, cost, and sustainability are addressed;
- capacity and failure behavior cover the planning horizon;
- alternatives and trade-offs are honestly recorded; and
- implementation can be staged into independently verifiable increments.

## Design Output

Use this structure unless the repository provides a template:

```text
System design:
1. Problem, outcome, scope, and stakeholders
2. Current state and constraints
3. Functional requirements and non-goals
4. Quality scenarios, workload, and SLOs
5. Context, components, responsibilities, and ownership
6. Data model, authority, and lifecycle
7. Interfaces and critical flows
8. Security, privacy, reliability, and overload behavior
9. Deployment, observability, and operations
10. Evolution and migration
11. Alternatives, decisions, trade-offs, and risks
12. Validation evidence and open questions
```

End with implementable next steps, decision owners, and explicit approval needs. Do not present assumptions as settled architecture or optional future work as already authorized.
