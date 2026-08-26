---
name: distributed-systems
description: Design and evaluate correctness across processes, services, nodes, regions, and asynchronous workflows under partial failure. Apply when communication, replication, partitioning, consistency, messaging, coordination, or distributed state affects behavior; do not distribute a simpler local design without evidence.
---

# Distributed Systems

Design for a world in which components fail independently, messages are delayed or duplicated, clocks disagree, processes restart, and callers cannot always know whether an operation completed. Preserve the simplest architecture that meets the actual fault, latency, scale, ownership, and deployment requirements.

Distribution is not a reliability feature by itself. Every network boundary adds failure modes, operational state, compatibility obligations, and ambiguous outcomes. Keep work in one process or transactional boundary when those costs are not justified.

## Working Method

For each distributed capability:

1. Define user-visible outcomes, invariants, service-level objectives, workload, data sensitivity, and geographic or regulatory constraints.
2. Draw the authoritative state, owners, communication paths, trust boundaries, and failure domains. Mark synchronous dependencies and asynchronous edges.
3. State the failure model: crashes, restarts, omission, delay, duplication, reordering, partitions, clock uncertainty, overload, stale replicas, and operator error as applicable.
4. Specify consistency, ordering, durability, availability, and completion semantics per operation and invariant.
5. Choose replication, partitioning, coordination, and workflow mechanisms that provide those semantics with the least distributed state.
6. Define behavior for timeout, cancellation, duplicate delivery, stale data, partial success, failover, recovery, replay, and topology change.
7. Add observability and operational controls before relying on automated retry, failover, or rebalancing.
8. Validate with realistic concurrency, load, fault injection, recovery, and mixed-version deployment.

Document assumptions that cannot be verified. An unstated assumption about network reliability, clocks, ordering, or duplicate delivery is a latent correctness defect.

## Non-Negotiable Guardrails

- **MUST** identify the system of record and the component that owns each business invariant.
- **MUST** assume remote calls can fail before, during, or after the remote effect, leaving completion unknown.
- **MUST** make duplicate, delayed, reordered, stale, and concurrently processed work safe wherever the transport can produce it.
- **MUST** preserve authorization, tenant isolation, data integrity, and auditability during retries, failover, replay, compensation, and disaster recovery.
- **MUST NOT** claim exactly-once effects solely because a broker, protocol, or framework advertises exactly-once delivery.
- **MUST NOT** use wall-clock time alone for causality, uniqueness, ordering, or lease safety unless bounded clock uncertainty is part of the proven design.
- **MUST NOT** add consensus, distributed locks, multi-region writes, event sourcing, sagas, or microservices without requirements that justify their failure and operational costs.
- **SHOULD** prefer single-writer ownership, local transactions, immutable messages, and monotonic state transitions when they simplify correctness.
- **SHOULD** keep coordination off high-volume paths unless the invariant requires it.
- **MAY** trade consistency, latency, or availability for another property only at an explicitly named operation and with acceptable user-visible behavior.

## Invariants and Consistency

Start with business invariants, not product labels such as “strong” or “eventual.” Examples include preventing double spending, preserving unique ownership, enforcing an inventory floor, maintaining per-account ordering, or showing a user their own accepted update.

For each read and write path, define the minimum required semantics:

- **Linearizability:** Each operation appears to take effect atomically between invocation and response, respecting real-time order.
- **Serializability:** Transactions behave like some serial execution, which does not necessarily preserve real-time order.
- **Snapshot or repeatable reads:** A multi-read operation observes a defined consistent version.
- **Read-your-writes:** A client can observe its accepted writes.
- **Monotonic reads or writes:** A client does not move backward through versions or reorder its own writes.
- **Causal consistency:** Causally related operations are observed in their dependency order.
- **Eventual convergence:** Replicas converge after updates stop, with a defined conflict rule.

Use the weakest model that still protects the invariant and user expectation, because stronger coordination typically costs latency and availability. Do not weaken semantics merely for theoretical throughput without a measured need.

CAP is a statement about the choices a replicated system can guarantee during a network partition under specific definitions; it is not a general “pick any two” product checklist. Also evaluate steady-state latency, replica lag, recovery, and consistency trade-offs when no partition is present.

Make staleness visible in design terms: maximum expected lag, version or timestamp exposed to callers, session guarantees, and behavior when the bound cannot be met. “Eventually consistent” is incomplete without convergence, conflict, and user-experience rules.

## Ownership and Data Boundaries

Assign one authoritative writer for a piece of state when possible. Other components should interact through an owned contract or maintain explicitly derived copies.

- Do not let multiple services mutate the same tables without a shared transaction and ownership model.
- Treat caches, indexes, search stores, projections, analytics stores, and materialized views as derived state with a rebuild or reconciliation path.
- Define which system wins when sources disagree and how drift is detected and repaired.
- Keep invariant-enforcing operations close to the authoritative data.
- Avoid chatty boundaries that require many remote calls to complete one logical operation.

Service boundaries should follow ownership, independent change, security, scaling, or failure-isolation needs. Splitting a coherent invariant across services creates coordination work; do it only when the ownership trade-off is deliberate.

## Replication and Failover

Choose replication based on required durability, read semantics, write availability, latency, and failure domains.

- Define leader, multi-leader, or leaderless write behavior and how conflicting writes resolve.
- State acknowledgement rules: which replicas or durable logs must accept a write before success is returned.
- Account for correlated failures; replicas in one power, network, software, credential, or administrative domain may not provide independent protection.
- Specify replica catch-up, snapshot installation, log truncation, data validation, and behavior when a replica is too stale.
- Prevent split-brain writes using a proven consensus or fencing mechanism when single ownership matters.
- Treat automatic failover as a state transition requiring detection thresholds, quorum, safe promotion, and controlled failback.
- Test membership changes and rolling replacement; quorum safety depends on configuration transitions, not only steady-state voting.

Quorum arithmetic is not sufficient by itself. Confirm failure detection, topology, read and write overlap, repair behavior, and what happens under clock or network asymmetry.

## Consensus, Coordination, and Leases

Use a mature, well-tested consensus implementation for replicated logs, leader election, membership, or linearizable coordination. Do not implement a custom consensus protocol as ordinary application code.

Distributed locks and leases require:

- a clearly protected resource and invariant;
- ownership identity and expiration semantics;
- renewal and cancellation behavior;
- a fencing token or monotonically increasing epoch checked by the protected resource; and
- safe behavior when a paused or partitioned former owner resumes.

A lease timeout alone does not stop the old holder from acting. If stale work can damage state, the state-changing system must reject an older fencing token.

Prefer commutative operations, compare-and-set, version checks, partitioned ownership, or deterministic conflict resolution over global locks when those mechanisms preserve the invariant.

## Time, Ordering, and Identity

Clocks measure different things:

- Use monotonic clocks for elapsed time, deadlines, and backoff.
- Use wall clocks for human time and external timestamps, while accounting for skew and correction.
- Use logical versions, sequence numbers, or causal metadata when ordering must not depend on synchronized physical time.

Define ordering scope precisely: global, per stream, per entity, per partition, or best effort. Global total order is expensive and rarely necessary.

- Include stable event or operation identifiers when deduplication or traceability is required.
- Use versions to reject stale writes and detect gaps.
- Do not infer causality from timestamps generated by independent clocks.
- Define tie-breaking and conflict behavior explicitly; “latest write wins” can lose valid updates and depends on clock and identity rules.
- Preserve event time, ingestion time, and processing time as separate concepts when lateness or replay matters.

## Partitioning and Placement

Partition state and work by an access pattern that distributes load while keeping important invariants local.

Evaluate:

- key cardinality and distribution;
- hot keys, hot tenants, skew, and correlated bursts;
- cross-partition reads, writes, joins, and transactions;
- routing metadata and behavior when it is stale;
- resharding, movement, dual reads or writes, and cutover correctness;
- tenant isolation, noisy-neighbor limits, and fairness; and
- locality, residency, egress, and latency requirements.

Hashing distributes many workloads but weakens range access and locality. Range partitioning supports scans but can create sequential hotspots. Composite, hierarchical, or time-bucketed keys have their own skew and lifecycle trade-offs.

Design for partitions to split and merge without losing identity, ordering, or idempotency state. Validate the largest tenant or hottest key, not only average distribution.

## Synchronous Communication

Every remote request needs a contract for:

- endpoint discovery and routing;
- authentication, authorization, encryption, and identity propagation;
- schema and semantic compatibility;
- deadlines and cancellation propagation;
- connection, concurrency, payload, and response limits;
- retryability and idempotency;
- overload and rate-limit signals; and
- partial or ambiguous completion.

Set an end-to-end deadline at the caller and propagate the remaining budget. Avoid multiplying full timeouts at each hop. Stop downstream work when the caller cancels or the result can no longer be used.

Minimize synchronous depth. The availability and tail latency of a request path are constrained by its required dependencies, and fan-out increases the chance of a slow or failed subrequest. Make optional dependencies genuinely optional with a defined degraded response.

## Messaging and Event Processing

Document the broker's actual guarantees separately for producer, storage, delivery, and consumer effects.

Common delivery models:

- **At-most-once:** A message may be lost but is not intentionally redelivered.
- **At-least-once:** A message is retried until acknowledged and may be delivered more than once.
- **Effectively-once effects:** Duplicate delivery is tolerated through idempotent state transitions, deduplication, or atomic broker-and-state integration within a defined scope.

For reliable processing:

- acknowledge only after the owned durable effect is committed;
- make consumers idempotent using the business operation identity, not merely transport delivery identity;
- define deduplication scope, storage, retention, and behavior after expiry;
- persist a state change and its outgoing message atomically through a transactional outbox or equivalent mechanism when both must occur;
- use an inbox or processed-operation record when consumer deduplication must survive restarts;
- bound redelivery and quarantine poison messages with enough safe diagnostic context;
- define replay behavior, side-effect suppression, and how consumers distinguish historical from live traffic; and
- monitor queue age, depth, throughput, retries, dead letters, processing latency, and consumer lag.

Ordering is normally guaranteed only within a partition or session and can conflict with parallelism. If an entity requires order, include a key, sequence, and stale-or-gap policy. Do not depend on global arrival order unless the infrastructure contract truly provides it.

Evolve event schemas compatibly. Events are durable facts consumed by independently deployed software; removal, semantic reuse, or silent reinterpretation of a field can break consumers long after publication.

## Distributed Workflows and Transactions

Keep atomic work inside one local transaction whenever possible. For work across independently owned stores, choose explicit semantics:

- orchestration with a durable workflow state machine;
- choreography with carefully bounded event relationships;
- saga-style local transactions and compensating actions;
- reservation and confirmation; or
- reconciliation toward a valid state.

For each step, define preconditions, idempotency, durable outcome, timeout, retry class, compensation, and terminal states. Identify the point after which an operation cannot truly be undone.

Compensation is not rollback: it is another business operation that can fail, race, or be only partially equivalent. Preserve an audit trail and provide manual reconciliation for states automation cannot resolve.

Avoid cycles and hidden feedback in event choreography. When understanding completion requires reconstructing many implicit reactions, prefer an explicit orchestrator or process model.

## Resilience and Overload

Retries consume capacity. Retry only transient failures, at one deliberate layer, with duplicate safety, capped attempts and duration, exponential or suitable backoff, jitter, and a shared retry budget. Respect downstream overload signals and remaining deadlines.

Protect the system with:

- bounded queues, concurrency, connections, payloads, and fan-out;
- admission control, rate limits, fairness, and per-tenant isolation;
- backpressure from consumers toward producers;
- load shedding that rejects work early and cheaply;
- bulkheads that prevent one dependency or tenant exhausting shared resources; and
- degraded modes whose correctness and recovery are explicit.

Circuit breakers and hedged requests can improve some failure modes but add state, synchronized behavior, and extra load. Introduce them only with measured thresholds, budgets, and recovery tests.

## Deployment, Recovery, and Evolution

Assume mixed versions during rolling deployment and delayed message processing.

- Make protocol and schema changes backward-compatible across the deployment window.
- Use expand-migrate-contract for durable schemas and events when immediate replacement is unsafe.
- Separate code rollout, data backfill, traffic shift, and cleanup into observable stages.
- Define rollback limits after new data formats or irreversible effects are written.
- Rehearse backup restoration, replica rebuild, regional recovery, and reconciliation; replication does not replace backup.
- Preserve idempotency and workflow state across restarts and disaster recovery.

Recovery objectives must match the design: recovery time, recovery point, data verification, dependency order, DNS or routing behavior, credential availability, and operator access.

## Security and Trust

Authenticate service and workload identity at every trust boundary and authorize at the operation that owns the resource. Do not trust internal network location as identity.

- Encrypt data in transit and at rest according to sensitivity.
- Limit credentials by service, environment, tenant, operation, and lifetime.
- Prevent confused-deputy behavior when one service acts for a caller.
- Preserve caller and decision identity through asynchronous work without forwarding overly broad credentials.
- Treat messages, replica traffic, routing metadata, and control planes as untrusted inputs where boundaries require it.
- Make replay protection, nonce or idempotency scope, and audit evidence consistent with the threat model.

Failover and degraded modes must not bypass authorization, validation, or tenant isolation.

## Observability and Operations

Provide a correlation model spanning requests, messages, retries, workflow steps, and durable state transitions. Use stable identifiers with bounded telemetry cardinality.

Measure user outcomes and distributed mechanics:

- availability, latency distributions, throughput, and correctness indicators;
- dependency errors, deadlines, cancellations, retries, and retry amplification;
- replica lag, quorum health, leader or membership changes, and repair backlog;
- queue age, consumer lag, duplicate rate, dead letters, and replay progress;
- partition load, skew, rebalancing, and hottest keys; and
- workflow age, stuck states, compensation, and reconciliation backlog.

Logs must distinguish expected rejections from system failures and avoid secrets or sensitive payloads. Traces are sampled evidence, not a correctness mechanism. Provide operational controls to pause consumers, drain traffic, quarantine messages, limit retries, and reconcile state safely.

## Validation

Validate invariants under histories, not only individual responses.

1. Test concurrent operations, duplicates, reordering, stale reads, lost acknowledgements, and ambiguous timeouts.
2. Inject process crashes before and after each durable boundary.
3. Test delay, packet loss, partitions, asymmetric reachability, clock skew, and dependency overload where the environment permits.
4. Exercise leader loss, quorum loss, replica catch-up, membership change, resharding, and failback for owned infrastructure.
5. Replay messages and restore backups into an isolated environment; verify resulting state, not merely job completion.
6. Run mixed-version compatibility tests across rolling deployment and rollback windows.
7. Load-test skewed and bursty workloads while observing queueing, tail latency, fairness, and recovery.
8. Verify dashboards, alerts, runbooks, and manual reconciliation using the same failure scenarios.

Use deterministic simulation, model checking, or state-machine/property testing for coordination logic when practical. Do not claim a distributed guarantee from a happy-path integration test.

## Decision Record

For material designs, report:

```text
Distributed decision:
- Invariants and owner:
- Failure model:
- Consistency and ordering:
- Delivery and idempotency:
- Partitioning and replication:
- Deadlines, retry, and overload policy:
- Recovery and mixed-version behavior:
- Evidence and validation:
- Trade-offs and unresolved risks:
```

Name the scope of every guarantee. Prefer “per-account ordered while a quorum is available” over unqualified claims such as “consistent,” “highly available,” or “exactly once.”
