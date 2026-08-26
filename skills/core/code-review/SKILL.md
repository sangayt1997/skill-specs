---
name: code-review
description: Review proposed or existing code for concrete correctness, security, reliability, performance, maintainability, testing, and operational risks. Apply when an evidence-backed assessment is requested; report prioritized findings without modifying code unless a fix is also requested.
---

# Code Review

Protect users and improve the codebase without blocking progress for personal preference or unattainable perfection. Review the behavior and system impact first, then implementation detail. Treat automated checks as evidence, not as a substitute for understanding the change.

This skill is review-only by default. Inspect, test, and report; do not edit files, push changes, approve a pull request, or change external state unless the user explicitly asks.

## Establish the Review Contract

Before judging the code, determine:

- the requested behavior and acceptance criteria;
- the review target and comparison base, including uncommitted changes when relevant;
- repository instructions, ownership boundaries, supported versions, and architectural conventions;
- whether the change is a feature, fix, refactor, migration, generated update, dependency update, or emergency patch; and
- the depth requested: focused diff review, security or performance review, architecture review, or broader audit.

If no base is specified, infer the most defensible base from repository state and state the assumption when it affects findings. Do not review unrelated pre-existing code unless it is directly affected or necessary to prove an issue in the requested change.

## Review Sequence

Use a risk-first sequence:

1. Read the change description, linked requirements, and relevant project guidance. Decide whether the change itself makes sense and is complete enough to review.
2. Inspect the change summary, file list, dependency or lockfile changes, migrations, configuration, public interfaces, and tests to form a system-level model.
3. Identify high-risk surfaces: trust boundaries, authorization, money, destructive operations, durable data, concurrency, external I/O, public APIs, compatibility, deployment, and rollback.
4. Review the central behavior and design before spending time on local style. Read surrounding code and call sites rather than relying on isolated diff lines.
5. Trace representative success, boundary, and failure paths end to end. Review every meaningful human-authored changed line within scope.
6. Inspect tests and documentation as independent artifacts; do not assume they are correct because they exist.
7. Run the narrowest useful static checks and tests when available, then broaden according to risk and repository cost.
8. Reconcile findings against observed behavior, existing contracts, and tool output. Remove duplicates and unsupported speculation.
9. Report findings by severity, followed by assumptions, residual risk, and validation performed.

If a foundational design issue invalidates much of the implementation, report it early rather than producing dozens of downstream comments that the redesign would eliminate.

## Review Standard

- **MUST** identify a concrete failure mode, violated contract, or material maintenance risk before presenting a blocking finding.
- **MUST** distinguish defects introduced by the change from relevant pre-existing problems.
- **MUST** account for callers, users, data, external systems, and operational behavior—not only whether the edited function compiles.
- **MUST** treat security, privacy, concurrency, accessibility, internationalization, cryptography, and domain-specific correctness as specialist areas; request or recommend qualified review when confidence is insufficient.
- **MUST NOT** approve or reject based on personal style when the repository has no governing rule and multiple choices are sound.
- **MUST NOT** report hypothetical issues without showing the reachable condition that makes them credible.
- **MUST NOT** assume passing tests prove correctness or failing tools prove the implementation is wrong without interpreting the result.
- **SHOULD** favor approval when the change clearly improves or preserves overall code health and remaining concerns are non-blocking.
- **SHOULD** keep findings focused on the changed scope; label optional improvements explicitly.
- **MAY** recommend splitting a change when its size or mixed concerns prevent a reliable review, safe rollback, or meaningful verification.

## Correctness and Contracts

Compare the implementation with the requirement and with existing observable behavior.

Check:

- input domains, boundary values, empty and missing values, malformed data, overflow, precision, encoding, and time semantics;
- conditional logic, precedence, loop termination, state transitions, invariants, and unreachable or unintentionally reachable branches;
- ordering, duplicates, identity, equality, idempotency, and partial-update behavior;
- public APIs, serialized formats, schemas, events, configuration, command-line interfaces, and backward compatibility;
- lifecycle and cleanup of files, sockets, transactions, locks, subscriptions, processes, and other resources;
- failure propagation, cancellation, timeouts, retries, rollback, and partial success; and
- behavior across supported platforms, runtime versions, locales, and feature configurations when relevant.

Trace values across boundaries. A local check is not sufficient if another layer normalizes, truncates, retries, caches, authorizes, or persists the value differently.

## Security and Privacy

Review from attacker-controlled entry points toward sensitive effects.

Check relevant changes for:

- validation and canonicalization at trust boundaries;
- authentication, authorization, ownership, tenant isolation, and least privilege at the operation that performs the effect;
- injection into queries, commands, templates, paths, URLs, headers, logs, or interpreters;
- unsafe deserialization, file handling, redirects, server-side requests, and resource exhaustion;
- secrets, credentials, personal data, sensitive metadata, and excessive logging or error disclosure;
- cryptographic design, randomness, signature verification, key handling, and unsafe custom primitives;
- dependency provenance, install scripts, workflow permissions, artifact integrity, and unexpected lockfile changes; and
- business-logic abuse, replay, duplicate submission, race windows, and bypass through alternate paths.

Automated security tools complement manual review. They rarely establish that authorization placement, business invariants, or complex data flow is correct. Escalate suspected high-impact vulnerabilities through the project's private security process rather than exposing exploit details in a public review.

## Reliability, Concurrency, and Operations

Examine how the change behaves outside the happy path:

- Are remote calls bounded by appropriate deadlines and cancellation?
- Are retries limited to transient failures, safe for duplicates, capped, and coordinated with outer retry layers?
- Is concurrency bounded, and are shared state, ordering, atomicity, deadlocks, starvation, and lost updates handled?
- Do transactions and multi-step workflows define what happens after partial failure?
- Can queues, caches, buffers, logs, or in-memory collections grow without a meaningful bound?
- Are startup, shutdown, health checks, background work, and cleanup behavior safe?
- Do logs, metrics, traces, and error context support diagnosis without exposing sensitive data?
- Can the change be deployed, rolled back, or disabled safely with mixed application and schema versions?

For migrations, check existing data, locking and duration, forward/backward compatibility, resumability, rollback limitations, and deployment order. For configuration changes, check defaults, validation, secret handling, and behavior when old or missing values are present.

## Design and Maintainability

Judge design in the context of the system rather than against a preferred pattern.

Check whether:

- responsibilities and dependency direction align with established architecture;
- names, types, and interfaces communicate the domain contract;
- state, mutation, side effects, and ownership are discoverable;
- abstractions represent stable concepts rather than speculative reuse;
- duplicated code represents duplicated knowledge that can drift;
- new dependencies or public APIs are necessary and proportionate;
- comments explain rationale and remain accurate; and
- the change introduces dead code, obsolete paths, incompatible conventions, or unnecessary complexity.

Do not demand broad cleanup as a condition of a focused fix unless the existing structure makes the requested change unsafe. Record unrelated improvements separately.

## Performance and Resource Use

Focus on credible workload-sensitive regressions:

- accidental unfavorable complexity, repeated scans, sorting, copying, serialization, or recomputation;
- N+1 queries, calls inside loops, unnecessary round trips, or oversized payloads;
- unbounded memory, concurrency, retries, queues, DOM growth, or result sets;
- blocking work on latency-sensitive threads or request paths;
- cache behavior, invalidation, cardinality, and memory bounds; and
- changes to query plans, indexes, batching, pagination, streaming, or backpressure.

Define the workload and triggering scale. Do not claim a performance defect from Big-O, a microbenchmark, or intuition alone when constants and I/O dominate. Request representative measurement when the practical impact is uncertain and material.

## Tests and Verification

Tests must demonstrate meaningful behavior, not merely execute the new lines.

Review whether tests:

- would fail for the defect or regression they claim to prevent;
- cover important success, boundary, invalid-input, failure, and recovery behavior;
- operate at the lowest level that proves the contract while using integration or end-to-end coverage for real boundaries;
- are deterministic, isolated as appropriate, and independent of execution order;
- assert observable outcomes rather than internal steps unnecessarily;
- avoid mocks that reproduce the implementation and fixtures that hide the relevant scenario; and
- remain readable and maintainable as production code evolves.

Check that removed or changed behavior has corresponding test updates and that snapshots or golden files were reviewed semantically rather than accepted blindly. If tests cannot be run, state that limitation instead of implying they passed.

## Documentation and Change Completeness

Require documentation when the change affects how users or maintainers build, configure, call, deploy, operate, troubleshoot, or migrate the system.

Check API references, examples, configuration documentation, changelogs or release notes when project policy requires them, migration guidance, generated documentation sources, and comments tied to changed behavior. Verify that implementation, tests, documentation, and change description agree.

Generated or vendored changes require provenance and reproducibility review. Inspect the generator input, version, command, or upstream source rather than line-reviewing opaque output as if it were hand-written code.

## Evidence and Severity

Every finding should contain:

1. a concise title describing the defect;
2. severity;
3. the narrowest useful file and line location;
4. the input, state, sequence, or environment that triggers it;
5. the observable consequence or violated contract; and
6. a fix direction when it is not obvious.

Use severity consistently:

- **Critical:** Credible path to severe security compromise, irreversible data loss or corruption, major outage, or similarly catastrophic impact.
- **High:** Likely correctness, security, compatibility, or reliability defect with substantial user or operational impact.
- **Medium:** Real defect with bounded impact, uncommon triggering conditions, or a material maintainability problem likely to cause future errors.
- **Low:** Non-blocking issue with limited impact; include only when worth the author's attention.
- **Nit/Optional:** Preference or polish that does not affect approval. Omit by default unless the user requests exhaustive feedback.

Severity combines impact and likelihood; it is not determined by code size. Do not inflate severity to force prioritization.

## Review Communication

Address the code and its effects, not the author. Explain why a change is needed, distinguish required changes from suggestions, and allow the author to choose among equally sound implementations.

When a review conversation reveals information future maintainers need, request that the code, test, comment, or durable documentation carry that information. A private explanation in the review tool does not repair unclear code.

If disagreement remains, identify the disputed requirement or trade-off, gather evidence, and escalate through the project's ownership process rather than repeating opinions.

## Output

Lead with findings ordered by severity. Keep summaries secondary to defects.

```text
Findings
- [High] Prevent cross-tenant update — path/to/file:42
  A caller can supply an object ID belonging to another tenant because the write
  checks authentication but not ownership. This permits unauthorized modification.
  Scope the lookup by tenant or enforce ownership at the write boundary.

Assumptions / questions
- The endpoint is reachable by ordinary authenticated users.

Validation
- Ran: <focused checks>
- Not run: <checks and reason>

Residual risk
- <areas not reviewed or requiring specialist validation>
```

If there are no actionable findings, say so directly and still report validation limits and residual risk. Never manufacture a finding to make the review appear thorough.
