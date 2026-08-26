---
name: backend-architecture
description: Design or revise server-side application structure, domain boundaries, service responsibilities, dependency flow, data access, background processing, and operational behavior. Apply when backend-wide organization or service decomposition is at issue; use system-design or distributed-systems guidance for broader topology and coordination decisions.
---

# Backend Architecture

Structure backend software so business rules remain coherent, changes stay localized, external mechanisms remain replaceable where valuable, and the service can be deployed, operated, and recovered safely.

Start with a well-modularized deployment. Split services only when independent ownership, scaling, security, release, technology, or failure isolation provides enough current value to justify network, consistency, observability, and operational costs.

## Working Method

1. Inspect repository structure, entry points, domain model, persistence, integrations, jobs, deployment, and ownership.
2. Identify business capabilities, invariants, transactional boundaries, data authorities, workflows, and change coupling.
3. Map dependencies across code, database, configuration, messages, build, runtime, and teams.
4. Propose the smallest boundaries and dependency direction that localize important changes.
5. Define contracts, transaction scope, consistency, errors, retries, security, and operational limits.
6. Design startup, shutdown, health, overload, observability, migration, and recovery.
7. Enforce boundaries using available language, package, build, schema, and ownership mechanisms.
8. Migrate one vertical slice at a time and validate behavior under normal and degraded conditions.

Do not reorganize the entire backend to implement a local change. Preserve project conventions unless they cause the demonstrated problem.

## Non-Negotiable Guardrails

- **MUST** keep each business invariant under one identifiable authority.
- **MUST** define dependency direction and prevent private implementation imports across boundaries.
- **MUST** separate trusted domain decisions from transport, framework, persistence, and vendor details where the separation has present value.
- **MUST** bound incoming work, resource pools, queues, retries, and background concurrency.
- **MUST** design health, graceful shutdown, observability, configuration validation, and migration alongside request handling.
- **MUST NOT** introduce microservices, messaging, repositories, generic base classes, or dependency injection solely as architecture ceremony.
- **MUST NOT** let multiple services write the same authoritative data without an explicit consistency protocol.
- **MUST NOT** hide cyclic dependencies behind service locators, global registries, or an event bus.
- **SHOULD** keep the common request path short, traceable, and free of unnecessary network hops.
- **SHOULD** prefer one clear implementation over premature extension points.

## Architecture Drivers

State which needs drive structure:

- business capabilities and rate of change;
- transactional invariants and data ownership;
- latency, throughput, availability, and recovery objectives;
- trust, tenant, compliance, and data-residency boundaries;
- independent deployment or scaling;
- team ownership and release coordination;
- integration protocols and failure behavior;
- batch, scheduled, asynchronous, or streaming work; and
- operational staffing, cost, and migration constraints.

Turn vague requirements into scenarios. “Loosely coupled” should mean a named change can ship without modifying another module; “independently deployable” means contracts tolerate version skew and no coordinated database write is required.

## Domain and Responsibility Boundaries

Group behavior that protects the same invariant, owns the same lifecycle, and changes for the same business reason. Use domain language consistently within a boundary and translate at integrations.

For each module or service define:

- responsibility and owner;
- authoritative data and invariants;
- commands, queries, events, and public contracts;
- permitted dependencies;
- transaction and consistency model;
- deployment and lifecycle;
- security/trust scope; and
- failure, capacity, and observability behavior.

Avoid one module per table, controller, or technical layer when a feature then spans the whole repository. Technical platform modules remain useful for narrow cross-cutting mechanisms.

## Application Shape

A practical backend often separates concepts without requiring a fixed folder pattern:

- **transport adapters** parse protocol input, authenticate context, validate shape, invoke an application operation, and map output;
- **application operations** orchestrate a use case and transaction without owning transport semantics;
- **domain policy** enforces business rules and state transitions;
- **ports/contracts** describe required external capabilities when substitution or boundary testing matters; and
- **adapters/infrastructure** implement persistence, messaging, clocks, identifiers, external services, and platform concerns.

Keep layers cohesive rather than forcing every request through empty wrappers. Direct framework or database use is acceptable for simple read paths when domain rules are not leaked and future replacement is not a current need.

Dependencies should generally point toward stable policy. Do not let domain objects depend on HTTP requests, ORM sessions, message envelopes, or vendor SDK types unless the boundary deliberately accepts that coupling.

## Application Operations and Transactions

Model each mutation as an explicit use case:

1. establish trusted identity and authorization context;
2. validate command semantics;
3. load authoritative state within scope;
4. enforce invariants;
5. apply one atomic transition where required;
6. persist and record outgoing effects durably; and
7. return a domain result mapped by the transport.

Keep transaction boundaries aligned with invariants. Do not hold database transactions open across slow network calls when avoidable. Use an outbox or equivalent durable handoff when a committed database change must lead to a message or side effect.

Expected validation, conflict, missing, and permission outcomes should be explicit. Unexpected faults should reach centralized diagnostics without exposing internals.

## Data Ownership and Persistence

One module/service owns writes to each authoritative dataset. Others use its contract, read replicas/views, or explicitly derived data.

- Keep ORM entities and database schemas behind the owning boundary when they are implementation details.
- Avoid generic repositories that erase domain queries and transactions.
- Use purpose-specific data access expressing access patterns.
- Prevent tenant or authorization scope from being optional.
- Keep schema migrations owned and compatible with rolling versions.
- Define derived data rebuild, reconciliation, and deletion propagation.

A shared database can support a modular monolith if table/schema access rules enforce ownership. Separate databases do not create autonomy when every request needs distributed coordination.

## Service Decomposition

Split a deployment only when the candidate boundary has:

- cohesive business capability and stable contract;
- independent data authority;
- independent release or scaling need;
- clear owner and on-call responsibility;
- tolerance for network latency, partial failure, and version skew; and
- a migration that does not require indefinite dual authority.

Merge or retain one deployment when interactions are chatty, transactions span both sides, models leak through the contract, or teams always change/release them together.

Microservices add service discovery, authentication, authorization, observability, deployment, capacity, testing, incident, and data-consistency work. Account for this explicitly rather than treating process separation as modularity.

## Synchronous Communication

Use synchronous calls when the caller needs an immediate outcome and the dependency can meet the allocated deadline.

- Define contract, timeout, deadline propagation, cancellation, retry eligibility, and idempotency.
- Bound connection pools and concurrent requests.
- Avoid deep chains and cyclic service calls.
- Return early when the caller's deadline cannot be met.
- Distinguish overload from permanent validation failures.
- Use circuit breaking only with understood recovery and fallback behavior.

Retries belong at one responsible layer, with capped attempts, exponential backoff, jitter, and a retry budget. Multiplying retries at several layers can amplify one action into a cascade.

## Asynchronous and Background Work

Use asynchronous processing when completion need not block the request, burst smoothing is valuable, or work has an independent lifecycle.

- Persist the handoff before acknowledging acceptance.
- Define delivery, ordering, idempotency, retries, poison handling, and terminal failure.
- Bound queue size, work age, attempts, and consumer concurrency.
- Scale consumers against downstream capacity and deadlines.
- Propagate trace and tenant/security context safely, but reauthorize sensitive execution when required.
- Make jobs restartable and checkpoint long work.

A queue is not capacity. If arrival exceeds sustainable processing, backlog and completion time grow without bound. Provide admission control and a drain-time model.

Scheduled work needs singleton/partition ownership, missed-run behavior, overlap rules, time-zone semantics, and safe replay. Do not rely on one process's local timer in a replicated deployment unless duplicates are harmless.

## Configuration and Secrets

Separate deploy-specific configuration from code. Validate syntax and semantics before accepting traffic. Prefer a last-known-good configuration when a bad dynamic update would otherwise cause an outage and security policy permits it.

- Define ownership, defaults, required values, source precedence, and reload behavior.
- Never put secrets in source, images, logs, or client-visible configuration.
- Use managed secret storage, least-privilege access, rotation, and revocation.
- Keep feature flags temporary, owned, observable, and removable.
- Do not let configuration create unreviewed arbitrary code or policy execution.

Environment parity concerns behavior, not identical scale. Document intentional differences and test production-relevant integrations.

## Startup, Readiness, and Shutdown

Startup should validate configuration, initialize required resources, run safe compatibility checks, and expose readiness only when the instance can serve correctly. Avoid every replica running migrations automatically unless coordination makes it safe.

Differentiate:

- liveness: process cannot recover without restart;
- readiness: instance should receive new traffic; and
- dependency/status diagnostics: detailed operator signal, not necessarily health-gate logic.

Health checks must be cheap, bounded, and not turn dependency slowness into a fleet restart cascade.

On shutdown, stop admission, mark unready, drain requests, stop claiming work, finish or checkpoint within a deadline, close resources, and release leases. Test termination during requests, jobs, and deployments.

## Resilience and Overload

Map dependencies and failure modes. For each dependency define deadline, pool, fallback, cache, retry, and failure isolation.

- Use bulkheads for resources with different criticality.
- Reject excess work before saturation.
- Bound queues and in-flight operations.
- Shed optional or low-priority work first.
- Degrade functionality without weakening correctness or security.
- Preserve capacity for health, recovery, and administrative control.
- Warm caches and traffic gradually after restart or failover.

Do not treat autoscaling as instant protection. Load-test beyond capacity to observe collapse and recovery. A health check, logger, retry loop, or cache refill can itself amplify failure.

## Security Architecture

Mark external, service, administrative, and data trust boundaries. Authenticate service and user identity, authorize every operation/resource, validate untrusted input, and minimize privileged data.

- Use least-privilege workload identities.
- Separate public, internal, and administrative entry points where risk warrants it.
- Keep secrets and credentials out of domain objects and telemetry.
- Protect outbound requests against SSRF and unsafe redirects.
- Encode outputs for their target context.
- Apply tenant scope consistently through data, jobs, caches, messages, and logs.

Backend-for-frontend or gateway layers may aggregate and adapt, but must not become an unowned policy bypass or a second source of domain truth.

## Observability and Operations

Expose structured logs, metrics, and traces around user/business operations, dependencies, queues, state transitions, and releases.

Include correlation, operation, outcome, latency, safe resource/tenant identifiers, version, and dependency status. Bound cardinality and redact secrets/personal data.

Define SLOs, dashboards, actionable alerts, runbooks, ownership, capacity review, backup/restore, and incident controls. Observability code must remain bounded during failure; synchronous logging or unbounded labels can cause an outage.

## Testing Architecture

- Unit-test domain policies and reducers/state transitions.
- Integration-test real persistence, serialization, transactions, queues, and adapters.
- Contract-test service/client compatibility.
- End-to-end-test a focused set of critical workflows.
- Load-test capacity, pools, queue drain, and overload.
- Fault-test timeouts, cancellation, duplicates, dependency loss, restart, and recovery.
- Security-test trust, tenant, authorization, and administrative boundaries.

Use test seams at actual boundaries. Do not create an interface for every class solely to mock it. A module that needs the whole application for every test may have hidden global state or lifecycle coupling.

## Incremental Evolution

1. Characterize behavior, contracts, data, and operational baselines.
2. Define the destination boundary and ownership.
3. Move one cohesive operation and its policy/data access.
4. Keep one write authority and use temporary forwarding adapters.
5. Add boundary enforcement when the direction is proven.
6. Measure correctness, latency, load, delivery, and incident effects.
7. Remove old routes, schemas, flags, sync paths, and permissions after exit criteria.

Avoid big-bang rewrites and indefinite bidirectional synchronization. Transitional states must be deployable, observable, secure, and recoverable.

## Validation and Decision Output

Before finishing:

1. Trace representative commands, queries, jobs, and failures end to end.
2. Inspect dependency graphs, cycles, public surfaces, data writes, and runtime calls.
3. Verify transaction, idempotency, timeout, retry, overload, and tenant behavior.
4. Test startup, readiness, graceful shutdown, deployment, rollback/repair, and recovery.
5. Run relevant unit, integration, contract, security, load, and fault tests.
6. Confirm owners, runbooks, dashboards, and migration exit criteria.

Report:

```text
Backend architecture decision:
- Drivers, constraints, and current evidence:
- Responsibilities, boundaries, and owners:
- Dependency direction and contracts:
- Data authority and transactions:
- Sync/async communication and failure behavior:
- Security, capacity, and operations:
- Alternatives and trade-offs:
- Migration and validation:
```

Do not call a backend clean, modular, resilient, or scalable based on layers and services alone. Demonstrate localized change, protected invariants, bounded failure, and operable behavior.
