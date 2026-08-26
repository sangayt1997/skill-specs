---
name: error-handling
description: Design and implement predictable failure semantics across functions, processes, APIs, jobs, user interfaces, and distributed workflows. Apply when defining, propagating, translating, recovering from, observing, or testing errors without hiding failures or leaking sensitive details.
---

# Error Handling

Make failure behavior an explicit part of every contract. A good design tells callers what failed, whether anything changed, whether retry is safe, what the user can do, and what operators need to diagnose the cause—without exposing sensitive internals.

Follow the target language and framework's established error model. Use exceptions, result values, status objects, error unions, or callbacks according to project conventions rather than imposing one universal mechanism.

## Working Method

For each operation or boundary:

1. Identify credible failure sources and classify them by meaning, ownership, recoverability, and whether retry can help.
2. Define the failure contract alongside the success contract, including partial effects and cleanup.
3. Handle a failure only at the layer that can add context, translate abstraction, compensate, retry, degrade, or present it appropriately.
4. Preserve the original cause and relevant structured context while crossing internal boundaries.
5. Translate failures at process, protocol, job, and user-interface boundaries into stable external semantics.
6. Add observability at the boundary that owns the outcome, avoiding duplicate reports from every layer.
7. Test representative failures, recovery, cleanup, and partial-work behavior—not only successful execution.

Do not build a taxonomy larger than callers can act upon. Distinguish failures when they require different behavior, not merely because their implementation causes differ.

## Failure Categories

Use categories appropriate to the domain. Common distinctions include:

- **Validation or domain rejection:** The request is understood but violates input, state, or business constraints. Retrying unchanged input will not help.
- **Authentication or authorization failure:** Identity or permission is insufficient. Responses must avoid revealing protected resource existence or policy detail.
- **Conflict or concurrency failure:** Current state, version, uniqueness, or ordering prevents the operation. A refreshed or explicitly reconciled attempt may succeed.
- **Not found or unavailable state:** A required resource does not exist or is intentionally not visible to the caller.
- **Transient dependency failure:** A temporary network, overload, rate, leader-election, or service condition may succeed later within a bounded policy.
- **Permanent dependency failure:** The dependency rejected the operation or cannot support it; automatic retry is inappropriate.
- **Timeout or deadline exhaustion:** The available time budget ended. The caller may not know whether a remote side effect completed.
- **Cancellation:** Work is no longer wanted. Preserve it as cancellation rather than misreporting an internal failure.
- **Resource exhaustion:** Capacity, quota, memory, disk, connection, queue, or concurrency limits prevent safe continuation.
- **Invariant or programmer defect:** An internal assumption was violated. Fail visibly and fix the defect rather than treating it as ordinary user input.

Do not classify solely from a low-level type or message. The same transport error may be transient before a commit, ambiguous during a commit, or irrelevant after a durable result was recorded.

## Non-Negotiable Guardrails

- **MUST** preserve correctness, authorization, transactionality, idempotency, data integrity, and cleanup when handling failure.
- **MUST** make it possible to distinguish success, expected rejection, cancellation, and unexpected system failure when callers need different actions.
- **MUST** preserve the original cause, stack or traceback, and structured diagnostic context internally when translating errors.
- **MUST NOT** swallow an error, return fabricated success, or substitute empty, null, stale, or partial data unless that fallback is an explicit contract.
- **MUST NOT** expose stack traces, queries, paths, secrets, credentials, tokens, personal data, dependency internals, or security-sensitive policy details to untrusted callers.
- **MUST NOT** retry without classifying the failure, proving duplicate safety, setting a time and attempt budget, and considering amplification across layers.
- **SHOULD** fail early at the boundary that can identify invalid work cheaply and authoritatively.
- **SHOULD** keep the success path readable while making exceptional paths explicit and testable.
- **MAY** degrade functionality when the product explicitly permits it and the fallback is bounded, observable, distinguishable from authoritative data, and safer than failure.

## Propagation and Translation

Let errors travel until a layer can make a meaningful decision.

- Add context that identifies the failed operation and relevant safe identifiers, not merely “operation failed.”
- Preserve machine-readable type or code separately from the human-readable message.
- Translate an error when crossing an abstraction boundary so callers do not depend on database drivers, HTTP clients, framework exceptions, or other implementation details.
- Keep the translation faithful. Do not turn permission denial into not-found, timeout into validation failure, or cancellation into internal error unless a deliberate security or protocol policy requires that mapping.
- Avoid catching every exception or error at intermediate layers merely to log and rethrow it.
- Use a top-level handler as a safety net for unexpected failures, not as the primary implementation of known domain behavior.

Wrap or chain causes using the language's native mechanism. If no cause mechanism exists, retain structured fields and diagnostic evidence without relying on parsing error-message text.

Do not use mutable global “last error” state or sentinel values that valid results can also contain. Make absence, partial success, and failure distinct when ambiguity could affect behavior.

## Catching, Cleanup, and Invariants

Catch only the failures the current scope can handle correctly. Broad catches are appropriate at process, request, worker, event-loop, or plugin isolation boundaries where they prevent one failure from escaping uncontrolled, provided unexpected failures are still surfaced and observed.

- Keep resource cleanup in the language's structured cleanup mechanism so it runs on success, failure, and cancellation.
- Make cleanup idempotent when multiple paths may invoke it.
- Preserve the primary failure if cleanup also fails, while retaining the cleanup failure for diagnosis.
- Do not perform complex recovery in destructors, finalizers, or shutdown hooks whose execution and resources are uncertain.
- Use assertions for internal invariants that indicate defects, not for untrusted input or ordinary runtime conditions.
- Do not catch fatal runtime conditions that the platform declares unsafe to recover from unless the platform provides an explicit isolation contract.

Fail-fast means stopping unsafe work close to a violated invariant; it does not mean crashing an entire multi-tenant system when the failing unit can be safely isolated.

## External API Errors

Define stable errors as part of the API contract.

For each externally meaningful error, specify:

- a stable machine-readable type or code;
- the protocol status with correct generic semantics;
- a safe human-readable summary;
- field-level validation details when they help correction;
- whether retry is appropriate and, when known, when to retry;
- an occurrence or correlation identifier safe to share with support; and
- documentation for client action and compatibility.

For HTTP APIs, use established status semantics and a consistent problem-details representation when the project supports it. A problem response may include fields such as `type`, `title`, `status`, `detail`, and `instance`; extensions should have defined names and semantics. Do not duplicate sensitive internal diagnostics in `detail`.

Keep status and body consistent. Use client-error statuses for faults the client can correct and server-error statuses for failures fulfilling a valid request. Authentication, authorization, conflict, rate, validation, and unavailable conditions should remain distinguishable where doing so is safe.

Clients must branch on stable status or error codes, not localized message text. Evolve the error schema compatibly and treat removal or semantic reuse of a published code as a breaking change.

## User-Facing Errors

Tell users what happened in terms they can act on.

- State the failed task, preserve user input when safe, and offer a valid next action.
- Distinguish validation, permission, connectivity, temporary service, conflict, and irreversible failure when the response differs.
- Do not blame the user or present raw exceptions, transport codes, or internal identifiers without explanation.
- Do not promise that retry will help when completion is ambiguous or failure is permanent.
- Make errors accessible: associate field errors with inputs, announce asynchronous failures, move focus only when it helps recovery, and do not rely on color alone.
- Localize user-facing prose while keeping machine codes stable.

When an operation may have succeeded despite a lost response, tell the user how to check status rather than encouraging blind repetition.

## Transactions and Partial Work

Define the atomicity boundary before choosing recovery.

- Use a transaction when all affected state shares a transaction manager and must commit together.
- Roll back on failure only when rollback is supported and does not erase a more important diagnostic or concurrent change.
- For distributed workflows, define durable state transitions, idempotency keys, deduplication scope, compensation, and reconciliation instead of pretending the workflow is atomic.
- Record enough progress to resume long-running work safely without replaying completed irreversible steps.
- Distinguish complete success, complete failure, partial success, accepted-for-processing, and unknown outcome.
- In batch operations, define fail-fast versus per-item results, ordering, continuation, and whether successful items remain committed.

Compensation is a new business operation and can fail. Make it observable and reconcilable rather than calling it rollback unless it truly restores the prior state.

## Timeouts, Deadlines, Cancellation, and Retries

Set an end-to-end time budget appropriate to the caller's objective and propagate the remaining deadline through downstream work. Include connection establishment, name resolution, queues, request processing, response transfer, and local post-processing when they consume the same user-visible budget.

- Stop or avoid work that cannot complete usefully before the deadline.
- Propagate cancellation through child tasks and remote calls where supported.
- Distinguish a caller cancellation from a system timeout in metrics and external semantics.
- Ensure cancellation triggers cleanup and does not leave locks, transactions, temporary files, or background work orphaned.

Retry only when all of the following hold:

1. The failure is plausibly transient.
2. The operation is idempotent, protected by a correctly scoped idempotency key, or known not to have taken effect.
3. Another attempt fits within the remaining deadline and retry budget.
4. Retrying will not violate rate limits, ordering, fairness, or downstream capacity.
5. The retry policy is owned at one deliberate layer.

Use capped attempts and duration, exponential or otherwise appropriate backoff, and jitter for contended distributed systems. Respect server retry guidance such as `Retry-After` when valid. Bound retries across the whole request path; nested independent retries multiply load and can turn a dependency failure into a cascading outage.

Do not retry invalid requests, permission failures, invariant violations, or permanent rejections. Be cautious after timeouts on non-idempotent operations because completion may be unknown.

Circuit breakers, hedging, and failover add state and failure modes. Use them only with an explicit policy, bounded resources, observability, and tests that justify their operational complexity.

## Asynchronous and Concurrent Work

- Observe every spawned task or promise through awaiting, joining, supervision, or an explicit detached-task policy.
- Define how sibling work is cancelled when one branch fails.
- Preserve multiple failures when they are independently useful; do not arbitrarily discard all but the last completion.
- Bound parallel work and failure accumulation.
- Ensure callbacks, event handlers, streams, and queues have a defined error channel and terminal behavior.
- For background jobs, define acknowledgement timing, retry ownership, poison-message handling, deduplication, maximum deliveries, and dead-letter or quarantine behavior.

Never detach work merely to make an error disappear from the request path. If work intentionally outlives the caller, transfer ownership to a durable or supervised component before reporting success.

## Logging, Metrics, and Tracing

Record an unexpected error once at the boundary responsible for the failed outcome. Intermediate layers may add context to the error or trace, but repeated full-stack logging creates noise and misleading error counts.

Include, when safe and relevant:

- stable error code or class;
- operation and component;
- correlation, trace, request, job, or tenant-safe identifiers;
- dependency and attempt information;
- duration and deadline state;
- retry, fallback, or compensation outcome; and
- the preserved cause and stack for unexpected failures.

Do not log secrets, access tokens, session identifiers, credentials, raw payment data, unnecessary personal data, or full sensitive payloads. Sanitize untrusted values to prevent log injection and cap their size.

Use log levels according to ownership and actionability. Expected validation failures usually do not require error-level stack traces. Page or alert on user-impacting symptoms and actionable service conditions, not every exception instance. Metrics should separate error classes, retries, timeouts, cancellations, fallbacks, and unknown outcomes without unbounded label cardinality.

## Fallback and Graceful Degradation

A fallback is valid only when callers can safely accept the weaker result.

- Define freshness, consistency, authority, and maximum age for cached or stale data.
- Mark partial or degraded results when treating them as complete would mislead users or downstream systems.
- Bound fallback cost so it does not overload another dependency.
- Prevent security checks, authorization, financial controls, and integrity validation from failing open unless the explicit threat model requires it.
- Make entry into and recovery from degraded mode observable.

Prefer an honest failure over plausible but incorrect data.

## Testing Failure Behavior

Test at the level that owns each contract:

- validation and mapping for every public error category;
- cause preservation and translation across layers;
- cleanup on success, failure, timeout, and cancellation;
- transaction rollback, partial commit, compensation, and unknown outcomes;
- retry classification, idempotency, caps, backoff, jitter bounds, and deadline exhaustion;
- concurrent failures, cancellation races, lost updates, and worker crashes;
- safe external messages and redaction of logs and traces;
- user recovery, accessibility, and preservation of input; and
- fallback activation, freshness, recovery, and observability.

Use deterministic clocks, schedulers, and fault injection when the project supports them. Avoid tests that merely assert an exception occurred; verify its type or code, relevant context, side effects, and caller-visible outcome.

## Validation and Reporting

Before finishing an error-handling change:

1. Trace at least one success, expected rejection, transient failure, unexpected failure, timeout, and cancellation path when applicable.
2. Verify that no failure becomes false success and no partial effect is left unexplained.
3. Confirm external errors are stable, protocol-correct, actionable, and free of sensitive internals.
4. Confirm logs and telemetry contain enough safe context and do not double-count the same failure.
5. Run focused tests, then integration or end-to-end tests for changed boundaries.
6. Review retry and fallback behavior under sustained dependency failure, not only a single injected fault.

Report material changes to public error contracts, retry or timeout policy, partial-success semantics, observability, and compatibility. State untested failure modes and uncertainty directly; do not claim resilience from a happy-path test suite.
