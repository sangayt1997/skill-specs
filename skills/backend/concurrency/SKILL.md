---
name: concurrency
description: Design, implement, debug, or review concurrent and parallel code with explicit ownership, synchronization, cancellation, ordering, bounded work, and resource lifetimes. Apply when threads, tasks, processes, async operations, shared state, or races affect correctness or throughput; consult the actual language and runtime memory model before selecting primitives.
---

# Concurrency

Build concurrent systems whose safety, progress, cancellation, and capacity properties can be explained and tested.

## Working method

1. Identify the unit of work, shared resources, required ordering, latency target, and maximum useful parallelism.
2. Inspect repository conventions and exact language/runtime documentation. Do not transfer assumptions between threads, async tasks, processes, or database transactions.
3. State invariants and ownership before choosing locks, atomics, channels, actors, or queues.
4. Define task lifetime, cancellation, deadline, error propagation, and shutdown behavior.
5. Bound concurrency and queued work from measured resource limits.
6. Implement the smallest synchronization surface that preserves the invariants.
7. Exercise races, cancellation, overload, partial failure, and shutdown with appropriate tooling.

## Non-negotiable guardrails

- Do not infer thread safety from tests passing or from an operation appearing atomic.
- Establish a documented happens-before or message-passing relationship for every cross-task state transfer.
- Do not use sleeps as synchronization, hide blocking work on event-loop threads, or hold a lock across unbounded I/O.
- Do not create unbounded threads, tasks, goroutines, retries, queues, or fan-out.
- Propagate cancellation deliberately. Do not swallow cancellation exceptions or detach work whose ownership is unclear.
- Keep authorization and tenant context immutable or explicitly propagated across task boundaries.
- Preserve existing behavior and scope; concurrency work does not authorize unrelated architecture changes.

## Model the work

Distinguish concurrency (work in progress), parallelism (simultaneous execution), asynchrony (non-blocking representation), and distribution (separate failure and consistency domains). Describe safety properties—what must never happen—and liveness properties—what must eventually happen.

Prefer immutable values and single ownership. When state must be shared, document who mutates it, which readers may observe it, and the synchronization protecting each invariant.

## Choose coordination deliberately

- Use sequential execution when parallel work would not improve the relevant bottleneck.
- Use structured task groups when child work should finish or cancel with its parent.
- Use bounded queues or channels for producer-consumer pipelines and explicit backpressure.
- Use mutexes for short synchronous critical sections over related state.
- Use atomics only for small invariants supported by the runtime memory model.
- Use actors or single-writer loops when serialized ownership simplifies complex state.
- Use database constraints, transactions, leases, or idempotency for cross-process coordination.

Never describe `volatile`, a concurrent collection, or a single atomic field as making a compound workflow safe. Check-and-act, read-modify-write, iteration, and multi-field invariants often require a larger atomic boundary.

## Locking and progress

- Keep critical sections small and free of callbacks or unpredictable I/O.
- Establish a global lock order when more than one lock may be acquired.
- Use scoped or RAII locking so exceptional exits release resources.
- Do not call unknown code under a lock unless its reentrancy and blocking behavior are contractual.
- Evaluate deadlock, livelock, starvation, priority inversion, and fairness separately.
- Use condition variables, semaphores, or notifications with predicate loops instead of polling.
- Treat optimistic algorithms as retries; bound them or provide a contention fallback where progress matters.

## Task lifetime, failure, and cancellation

Prefer structured concurrency: child tasks belong to a scope, failures are collected, and the parent does not finish while owned work is running. For every spawned operation define:

- who awaits or joins it;
- how its error becomes visible;
- how it receives deadlines and cancellation;
- which resources it owns;
- whether partial results are usable;
- how cleanup behaves if cancellation arrives during cleanup.

Use monotonic time for elapsed durations. A timeout is a cancellation request, not proof that remote work stopped. Make cancellation-safe transitions explicit and shield only the minimum cleanup that must complete.

## Bound load and resources

Choose limits from downstream capacity, connection pools, file descriptors, memory per task, rate limits, and latency objectives. A worker pool with an unbounded admission queue merely moves overload.

- Reject, shed, delay, or degrade work intentionally when capacity is exhausted.
- Avoid nested pools that can wait on one another.
- Align database and HTTP client pools with worker limits.
- Preserve backpressure end to end; do not eagerly buffer an unbounded stream.
- For CPU work, account for scheduling and oversubscription.
- For I/O work, limit by the constrained dependency rather than processor count alone.

## Ordering, duplication, and consistency

Do not promise global ordering when only per-key or per-partition ordering exists. Across retries or queues, assume work may run more than once unless the system proves otherwise; use idempotency keys, unique constraints, or transactional transitions for important effects.

Local locks do not protect across processes. Distributed locks need ownership tokens, expiry semantics, fencing where stale holders could write, and failure analysis for pauses or partitions. Prefer database-enforced invariants when the database is the source of truth.

## Shutdown

1. Stop admission.
2. Signal cancellation or close producers.
3. Drain accepted work within a deadline.
4. Release resources after their users finish.
5. Report incomplete work without pretending success.

Closing a shared queue, executor, connection, or file is an ownership operation. Prevent writes after closure and partially initialized observations.

## Testing and diagnosis

- Run the ecosystem's race detector, thread sanitizer, deadlock detector, or concurrency analyzer when available.
- Replace sleeps with barriers, latches, controllable clocks, or deterministic schedulers.
- Force contested interleavings and repeat stress tests to expose rare schedules.
- Test cancellation before start, during waits, mutation, and cleanup.
- Test saturation, slow consumers, worker failure, and shutdown with work in flight.
- Verify results and liveness with bounded test deadlines.
- Treat flakiness as evidence to investigate, never as a reason to add arbitrary delay.

Instrument active work, queue depth and age, saturation, rejected work, wait time, duration, cancellations, and timeouts. Keep identifiers low-cardinality and propagate trace context intentionally.

## Completion report

Report the concurrency model, owned and shared state, invariants, limits, cancellation and shutdown semantics, failure behavior, verification performed, and residual risks. If correctness depends on a runtime guarantee, cite its versioned memory-model or synchronization documentation.
