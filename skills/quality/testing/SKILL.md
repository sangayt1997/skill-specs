---
name: testing
description: Plan, implement, or review a risk-based automated testing strategy across unit, integration, contract, end-to-end, performance, security, and resilience checks. Apply when deciding the overall confidence portfolio or quality gates; use a narrower testing skill for a single test layer.
---

# Testing

Build the smallest maintainable test portfolio that gives timely evidence about the product's important risks.

## Working method

1. Identify user journeys, business invariants, interfaces, failure modes, security boundaries, supported environments, and change frequency.
2. Inspect existing tests, CI stages, production incidents, flaky tests, observability, and repository conventions.
3. Map each material risk to the cheapest test boundary that can detect it faithfully.
4. Define ownership, data/environment strategy, gates, diagnostics, and acceptable execution time.
5. Implement or improve tests alongside behavior changes, then measure signal quality.
6. Remove redundant or misleading tests when stronger coverage supersedes them.

## Guardrails

- Test observable behavior and contracts, not private implementation structure.
- Never weaken assertions, add arbitrary waits, or indiscriminately retry to make failures disappear.
- Keep tests independent and safe to run in parallel; no test may require another to run first.
- Do not call production services or mutate valuable external data unless explicitly authorized and isolated.
- Treat coverage percentage as a diagnostic, not proof of correctness or a target to game.

## Design the portfolio

Favor many fast deterministic checks near the code, focused integration tests at real risk boundaries, and a small set of high-value system journeys. The exact shape depends on architecture and risk; do not enforce a geometric “pyramid” when contracts, data systems, UI, or legacy boundaries require a different balance.

Map risks deliberately:

- pure decisions and edge cases → unit/property tests;
- persistence, serialization, framework wiring, and adapters → integration tests;
- service interfaces → provider/consumer contract tests plus selected integration tests;
- critical user outcomes → end-to-end tests;
- latency/capacity → representative performance tests;
- authorization and abuse cases → security-focused tests;
- retries, failover, and recovery → resilience exercises.

Static analysis, type checking, linting, schema validation, and dependency scanning complement tests; do not reproduce their guarantees with brittle runtime assertions.

## Test design

Use arrange–act–assert or another locally clear structure. Name the behavior, condition, and expected result. Cover equivalence classes, boundaries, invalid input, state transitions, permissions, time, retries, and important failure paths. Property-based or model-based testing is valuable where many inputs share invariants.

Use realistic fixtures that reveal schema and serialization problems without becoming huge mystery datasets. Build only the data relevant to the scenario. Control clocks, randomness, identifiers, locale, and scheduling through explicit seams; record seeds for reproduction.

## Doubles and environments

Use fakes, stubs, mocks, spies, and emulators according to the question being answered. Mock at owned boundaries, not every internal call. A mock cannot prove compatibility with the real dependency, so pair it with contract or integration evidence where drift matters.

Provision isolated, reproducible environments from versioned configuration. Pin meaningful dependency versions, reset state between tests, and keep secrets out of fixtures and artifacts. Use production-shaped data distributions without copying sensitive production data.

## Reliability and diagnostics

A flaky test is a defect. Classify failures as product, test, environment, or infrastructure; preserve traces, logs, screenshots, request IDs, and seeds. Quarantine only with an owner, visible tracking issue, expiry, and retained signal. Retries may measure flakiness but must not turn a failing gate green without exposing the original failure.

Keep assertions precise and diagnostic. Avoid snapshots for volatile or security-sensitive output; review meaningful snapshot changes as carefully as code.

## CI and maintenance

Order feedback by cost and value: fast deterministic gates first, then broader suites. Shard only tests that are isolated. Track duration, failure rate, retry rate, queue time, and defect escape by suite. Establish ownership for fixtures, environments, and recurring failures.

When behavior changes, update tests because the contract changed—not merely to mirror the implementation. Delete obsolete tests and periodically inspect whether each expensive suite catches defects worth its cost.

## Completion report

Report the risk map, chosen test boundaries, important scenarios, data/environment isolation, CI placement, commands and results, coverage gaps, flakiness or diagnostic concerns, and follow-up work. Distinguish tests actually run from tests only recommended.
