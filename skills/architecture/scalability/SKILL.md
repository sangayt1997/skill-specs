---
name: scalability
description: Design and evaluate systems that preserve required service levels as traffic, data, tenants, geography, and workload cost grow. Apply when capacity, bottlenecks, partitioning, load distribution, elasticity, overload, or growth limits affect a design; do not add distributed complexity before measuring the simpler system.
---

# Scalability

Make growth behavior explicit, measurable, and safe. A scalable design sustains required outcomes across a stated operating range; it does not merely add instances or pass one peak-throughput test. Treat scalability as an end-to-end property: faster application nodes do not help when a database, lock, partition, dependency, network path, operator process, or budget is limiting.

## Working Method

1. Define the workload, growth dimensions, SLOs, constraints, and planning horizon.
2. Establish a measured baseline for throughput, latency, utilization, concurrency, errors, backlog, and cost.
3. Trace representative requests and jobs through every resource they consume.
4. Identify the first saturation point, serial fraction, contention boundary, and failure mode.
5. Select the smallest intervention that moves the relevant limit while preserving correctness.
6. Define capacity, scaling, overload, isolation, and recovery behavior together.
7. Test normal, peak, skewed, degraded, and beyond-capacity conditions.
8. Record assumptions, limits, evidence, operational controls, and the next expected bottleneck.

Prefer a measured vertical or local optimization when it meets the planning horizon with acceptable headroom. Add partitioning, asynchronous processing, replication, or services only when their operational and correctness costs are justified.

## Non-Negotiable Guardrails

- **MUST** state the workload model and success criteria before claiming a design scales.
- **MUST** preserve correctness, security, isolation, durability, and SLO priorities while scaling.
- **MUST** protect every bounded dependency from overload; scaling one tier must not flood another.
- **MUST** define hard limits and behavior beyond them. No finite system has unlimited capacity.
- **MUST NOT** infer capacity from average traffic, CPU utilization, or requests per second alone.
- **MUST NOT** claim linear scaling without measurements across representative scale points and skew.
- **MUST NOT** use caching, queues, replicas, or autoscaling as substitutes for understanding the bottleneck.
- **MUST NOT** make partition count, worker count, retry rate, queue depth, or retained data unbounded.
- **SHOULD** keep operational complexity proportional to demonstrated growth and reliability needs.
- **SHOULD** fail predictably through admission control, prioritization, or graceful degradation before uncontrolled saturation.

## Define the Workload

Describe load in units tied to resource cost, not only users or requests:

- steady, peak, burst, launch, seasonal, and batch arrival rates;
- concurrent operations and session duration;
- read/write mix, payload sizes, fan-out, and query complexity;
- data volume, item count, index size, retention, and growth rate;
- tenant distribution and the largest tenant's share;
- key popularity, geography, and access skew;
- background work, maintenance, migrations, replication, and recovery traffic; and
- upstream retry behavior and downstream quotas.

Distinguish a business transaction from internal work. One user action may create many RPCs, queries, messages, cache operations, or storage requests. Include those amplification factors. Represent uncertainty with ranges and scenarios; state forecast source, date, planning horizon, and safety margin.

## Define Required Outcomes

Tie capacity to observable objectives: accepted and completed throughput; latency distributions; availability, correctness, durability, and freshness; queue wait and completion deadlines; recovery targets; tenant fairness; and cost ceilings.

Specify which outcomes may degrade under pressure and in what order. The system may omit recommendations, serve acceptably stale data, lower fidelity, defer background work, or reject low-priority operations while protecting core transactions. Never silently weaken a correctness or security invariant for throughput.

## Establish a Baseline

Measure a representative production-like system. Collect:

- offered, admitted, completed, rejected, and retried work;
- latency percentiles and timeouts by operation;
- utilization and saturation for compute, memory, storage, network, connections, threads, pools, locks, and quotas;
- queue depth, oldest age, arrival rate, and drain rate;
- cache hit ratio together with origin load;
- query rate, scanned rows or bytes, lock wait, replication lag, and storage growth; and
- resource and monetary cost per useful unit of work.

Correlate metrics across tiers. High latency with low average CPU can indicate a saturated shard, lock, pool, quota, garbage collector, or tail-sensitive fan-out. Profile the critical path and quantify demand per operation; do not optimize the busiest-looking component unless it limits throughput or SLO attainment.

## Model Capacity

For every bounded resource, estimate:

```text
required capacity = forecast peak work × work per operation × safety factor
usable capacity   = provisioned capacity × efficiency × availability allowance
headroom          = usable capacity - required capacity
```

Adjust for skew, replication, maintenance, failover, and recovery. Capacity that works only when every node is healthy is not failover capacity. Because wait time and tail latency can rise sharply near a service limit, set an operating target below collapse rather than treating 100% utilization as efficiency.

Calibrate resource-to-capacity ratios with load tests and refresh them after material code, dependency, data-shape, or infrastructure changes. Forecasts and benchmarks are inputs, not guarantees.

## Find the Limiting Constraint

Ask:

- What saturates first as offered load rises?
- Is the constraint throughput, concurrency, latency, storage, bandwidth, quota, or coordination?
- Is it global, per node, partition, tenant, or key?
- Does skew create a hotspot before aggregate capacity is used?
- Does failure or maintenance expose a different limit?
- Does adding workers increase contention or overwhelm a dependency?
- What bottleneck appears after this one moves?

Parallel capacity cannot remove a global lock, single writer, ordered coordinator, or inherently serial step. Reduce or partition serialized scope only when its invariant permits it.

## Choose a Scaling Intervention

Consider options in increasing operational complexity:

1. Remove unnecessary work, round trips, scans, serialization, and amplification.
2. Improve algorithms, indexes, batching, data access, and resource reuse.
3. Scale the constrained resource vertically within cost and availability limits.
4. Replicate read-only or independently executable work.
5. Scale stateless processing horizontally.
6. Partition state and work by a stable key.
7. Redesign ownership or consistency only when earlier options cannot meet requirements.

Document the new limit and rollback path. Vertical scaling may best meet the horizon at lower risk. Horizontal scaling works when work is independently distributable, but adds coordination, balancing, deployment, and failure concerns.

## Stateless Compute and Session State

- Store durable state in an appropriate authority, not process memory.
- Treat local caches as disposable and reconstructable.
- Avoid correctness dependence on affinity; if it is necessary, define remapping and failure behavior.
- Coordinate scheduled or singleton work so replicas do not duplicate it accidentally.
- Bound in-memory queues and work in progress.
- Support graceful shutdown, connection draining, and lease expiry during scale-in.

Stateless does not mean without state; it means an instance is not the sole durable owner of state needed later.

## Partitioning

Partition when one resource or coordination domain cannot meet the required range. Choose a key supporting even distribution under real skew, locality for atomic or frequent operations, stable routing, bounded fan-out, tenant isolation where needed, and feasible split, merge, rebalance, and recovery.

Evaluate cardinality, monotonic keys, popular entities, large tenants, time concentration, and adversarial inputs. Hashing improves average distribution but loses locality; range partitioning preserves locality but can form moving hotspots.

Define routing authority, ownership transitions, and duplicate or missing routing behavior. Pre-partitioning can avoid disruptive moves but adds management cost. Dynamic partitioning needs tested split and merge controls. Do not scatter an operation across all partitions unless its bounded cost is acceptable; create deliberate indexes or aggregations for cross-partition access.

## Replication and Read Scaling

Replicas may increase read capacity and availability, but do not automatically scale writes.

- Define which reads may use replicas and their freshness or monotonicity requirements.
- Account for replication bandwidth, apply capacity, and lag during bursts.
- Route read-after-write and consistency-sensitive traffic appropriately.
- Ensure failover capacity absorbs promoted traffic and recovery work.
- Prevent replica count from multiplying expensive queries or jobs.

If writes require one leader or conflict-resolution domain, model its capacity directly. Changing consistency or adopting multi-writer replication is a correctness decision, not a routine optimization.

## Caching

Use caching only when reuse is measured and freshness semantics are explicit. Define the key and tenant/security scope, source of truth, TTL and invalidation, eviction bounds, miss and fill behavior, and protection against stampedes, hot keys, and synchronized expiry.

Measure hit ratio by operation and cost. A high ratio can hide an origin that collapses on cold start, failover, or cache loss. Test the origin at expected misses and during widespread eviction. Do not cache authorization decisions or sensitive data without correct identity scope, revocation, encryption, and retention.

## Asynchronous Work and Queues

Use asynchronous processing when the user-visible path need not wait and the business deadline allows delay.

- Bound queue size, message age, retries, and retention.
- Scale consumers from arrival rate, processing rate, backlog age, and downstream capacity—not depth alone.
- Limit aggregate consumer concurrency to what dependencies sustain.
- Make processing idempotent when delivery can repeat.
- Define ordering, poison-message handling, and dead-letter recovery.
- Apply backpressure when producers outrun sustainable processing.

A queue absorbs a burst only if the backlog drains before its deadline and within storage limits. It does not create downstream capacity. State drain time under peak and degraded consumer capacity.

## Load Distribution

Balance according to available capacity and work cost, not request count alone.

- Remove unhealthy or draining instances promptly without unstable flapping.
- Consider least-loaded, locality-aware, or weighted routing when capacities differ.
- Bound connection concentration and long-lived session skew.
- Detect partition, tenant, key, and geographic hotspots separately from fleet averages.
- Account for failover traffic and load-balancer convergence.

Validate any randomized or load-aware routing algorithm against the actual workload and health signals.

## Autoscaling as a Control Loop

Autoscaling is delayed feedback, not instant capacity. Define:

- a signal tied to the actual bottleneck;
- target, minimum, maximum, step size, and partition or regional bounds;
- observation window, startup, warm-up, cooldown, and stabilization;
- scale-out and scale-in asymmetry;
- dependency capacity and quota ceilings;
- scheduled scaling for predictable demand; and
- alerts for maximum capacity and scaling failures.

CPU is useful only when it tracks limiting work; queue age, concurrency, throughput per instance, latency, or custom saturation may be better. Keep enough headroom and overload protection for demand during detection and startup. Test oscillation, delayed metrics, failed provisioning, shortages, and scale-in while work is active.

## Overload and Admission Control

Treat overload as expected. Protect the system before saturation with:

- global, tenant, operation, and dependency-specific concurrency or rate limits;
- bounded queues and in-flight work;
- early rejection with safe retry guidance;
- load shedding by business priority and work cost;
- graceful degradation of optional features;
- deadlines and cancellation propagated through calls; and
- retry budgets, exponential backoff, jitter, and attempt limits.

Limit what saturates first. A request-rate limit cannot protect concurrency-bound fan-out, and a global limit can let one tenant starve others. Early rejection is safer than work that times out after consuming resources. Test rejection and recovery: retryable errors without coordinated backoff amplify overload.

## Multi-Tenant Isolation

Attribute consumption to a tenant or principal. Define quotas, concurrency, storage, and priority by tier; partition pools, queues, caches, or data where stronger isolation is justified; observe noisy-neighbor effects per tenant; and return explicit quota failures.

Isolation trades utilization for blast-radius control. Choose pooled, partitioned, or dedicated capacity from SLO and risk requirements rather than convention.

## Data Growth and Lifecycle

Model raw data plus indexes, replicas, logs, backups, versions, and migration copies. Include write amplification, compaction, restore and scan time, maintenance windows, identifier range, and retention obligations.

Define archival, aggregation, deletion, and restore verification. Test schema and index changes at future-scale volumes; a migration safe today may exceed locks, logs, or maintenance windows later.

## Failure Domains and Geographic Growth

- Size for the required loss scenario: instance, zone, region, partition, or dependency.
- Avoid correlated placement and keep failure domains explicit.
- Shift traffic slowly enough that failover does not overload its destination.
- Consider cells or tenant groups when blast-radius limits justify duplicated capacity.
- Include repair, rebalancing, replication, and cache warming in degraded tests.

New regions alter latency, consistency, residency, deployment, and response. Do not use geographic replication as a shortcut when simpler partitioning or routing meets the need.

## Cost and Operational Scalability

Track cost per useful operation, tenant, or data unit where feasible. Include idle headroom, cross-zone traffic, replicas, observability, backup, support, and engineering operations. Identify discontinuities such as license tiers, quotas, partition limits, and dedicated clusters.

A design requiring manual intervention proportional to customers, partitions, or nodes does not scale operationally. Automate repeatable provisioning, placement, repair, and verification with safe limits and human override.

## Validation

Use production-representative data shape, request mix, dependency behavior, and topology. Run as applicable:

- baseline and regression tests;
- steady and peak load tests;
- stress tests beyond capacity to identify collapse behavior;
- spikes faster than autoscaling response;
- soak tests for leaks, compaction, and backlog drift;
- skew and hot-key tests;
- failover tests at peak load;
- cold-cache, restart, recovery, and rebalance tests; and
- scale-out and scale-in tests at configured bounds.

Measure offered versus completed work, percentile latency, saturation, errors, shedding, backlog age, correctness, and cost. Declare environment, dataset, duration, warm-up, client limits, uncertainty, and production differences. Do not extrapolate from an optimized happy path.

## Observability and Capacity Operations

Provide dashboards and alerts for SLO indicators, offered/admitted/completed/retried/rejected load, saturation by tier and tenant, queue age and drain time, autoscaling decisions and bounds, data growth and time to limit, and unit-cost or forecast divergence.

Assign capacity owners, review cadence, forecast inputs, provisioning lead time, and escalation thresholds. Revalidate before launches, migrations, major features, pricing changes, or traffic shifts.

## Decision Output

```text
Scalability decision:
- Workload and planning horizon:
- SLOs and protected invariants:
- Baseline and test environment:
- Current bottleneck and evidence:
- Chosen change and rejected alternatives:
- Capacity model, headroom, and hard limits:
- Scaling and overload behavior:
- Failure, tenant, and data-growth considerations:
- Validation results:
- Cost, operational impact, and next bottleneck:
```

State what range has been demonstrated and what remains an estimate. “Horizontally scalable” and “cloud native” are not evidence.
