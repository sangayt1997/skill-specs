---
name: e2e-testing
description: Design, implement, diagnose, or review end-to-end tests for critical user outcomes through deployed system boundaries. Apply when browser, mobile, CLI, or cross-service journeys require whole-system confidence; keep the suite small, isolated, observable, and resilient to irrelevant implementation changes.
---

# End-to-End Testing

Prove a limited set of high-value journeys as a user or external client experiences them.

## Select journeys

Prioritize revenue, access control, data loss, onboarding, and previously escaped failures. Define the actor, starting state, action, visible outcome, durable side effect, and important failure case. Do not mirror every lower-level test through the UI.

Keep one clear purpose per scenario while permitting a coherent workflow. Test across supported browsers/devices only where compatibility risk warrants the matrix. Separate smoke gates from broad regression suites.

## Build reliable tests

1. Provision an isolated environment and scenario-owned data through stable APIs or fixtures.
2. Enter through a public interface and use user-visible semantics.
3. Synchronize on observable readiness and outcomes, not fixed sleeps.
4. Assert the user result and critical durable effect.
5. Capture trace, screenshot/video, console, network, server logs, and correlation IDs on failure.
6. Clean up safely, while ensuring isolation does not depend on cleanup succeeding.

## Guardrails

- Never point tests at production or destructive shared data without explicit authorization and purpose-built safeguards.
- Tests must run independently, in any order, and in parallel with unique data.
- Do not use arbitrary delays, brittle DOM paths, pixel coordinates, or assertions on private implementation state.
- Do not automatically retry away failures. Preserve the original attempt and track retry success as flakiness.
- Keep secrets and personal data out of source, screenshots, traces, and CI artifacts.

## UI interaction

Prefer accessibility role, name, label, and visible text locators because they reflect user-facing contracts. Use explicit stable test IDs when no semantic locator exists. Avoid CSS/XPath tied to component hierarchy.

Use the framework's auto-waiting and retrying assertions. Wait for a specific state, response, event, or durable record with a deadline. Avoid “network idle” as a universal readiness signal for applications with polling or streaming.

Interact as a user would, but create expensive prerequisite state through supported setup APIs when the setup itself is not under test. Authentication state may be reused only when tests cannot mutate one another's account state and expiry is controlled.

## Distributed and external behavior

For asynchronous workflows, correlate the request and poll a stable observable result within a bounded deadline. Account for duplicate delivery and eventual consistency. Decide whether third-party sandboxes are reliable enough for a gate; otherwise stub the remote edge and maintain separate contract or scheduled live checks.

Control feature flags, clock, locale, timezone, email/SMS capture, and payment sandbox behavior explicitly. Verify rollback or compensating behavior for high-risk partial failures.

## Flakiness and performance

Classify failures before changing tests: product defect, test defect, environment, or infrastructure. Reproduce with saved traces and exact seed/data. Quarantine only with a visible owner, issue, expiry, and continued execution outside the blocking gate.

Parallelize only isolated scenarios. Track runtime, failure and retry rate, queue time, and defect yield. Keep end-to-end assertions focused; move exhaustive permutations to cheaper layers.

## Completion report

Report journeys and risks covered, environments and supported matrix, data isolation, locator and synchronization strategy, external substitutions, commands/results, failure artifacts, flakiness status, runtime impact, and lower-level or manual gaps.
