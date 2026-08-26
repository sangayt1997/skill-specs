---
name: ci-cd
description: Design, implement, harden, or review continuous-integration and delivery pipelines for validation, builds, artifacts, provenance, promotion, and deployment gates. Apply when repository automation or release flow changes; preserve least privilege and do not trigger external releases without authorization.
---

# CI/CD

Create fast, reproducible, least-privilege pipelines whose artifacts can be traced to reviewed source.

## Working method

1. Inventory branch rules, trust boundaries, event triggers, required checks, environments, runners, secrets, artifact stores, and current commands.
2. Separate untrusted validation from privileged publishing or deployment.
3. Order stages for fast feedback: deterministic static checks, focused tests, broader tests, build, package, scan, attest, then authorized promotion.
4. Build an immutable artifact once and promote that same digest through environments.
5. Add concurrency, timeout, retry, caching, and cleanup controls with explicit semantics.
6. Test pull-request, mainline, tag, manual, failure, and cancellation paths as relevant.

## Security guardrails

- Grant the workflow token and job credentials only the permissions they need; default to read-only.
- Never expose secrets to untrusted fork code or interpolate untrusted event data into shell scripts.
- Pin third-party workflow code to reviewed immutable revisions where the platform supports it, and retain human-readable update context.
- Prefer short-lived federated credentials over static cloud keys; scope environments and require approvals for sensitive targets.
- Treat caches and artifacts from untrusted contexts as potentially poisoned. Separate trust domains and validate provenance.
- Do not let a pull request modify the privileged workflow that executes it with secrets.

## Reproducibility and artifacts

Pin toolchain and dependency inputs according to ecosystem practice. Record source revision, build parameters, dependency lockfiles, builder identity, and artifact digest. Generate an SBOM and provenance when the project or threat model warrants it. Sign or attest release artifacts through a protected identity.

Avoid rebuilding per environment. Configuration belongs at deployment/runtime unless it truly changes the artifact. Define artifact retention, access, immutability, and cleanup.

## Pipeline behavior

Jobs must have bounded timeouts and cancellation. Use concurrency groups to cancel obsolete validation while never canceling a release mid-mutation without a safe resume path. Retry only demonstrably transient idempotent operations with a limit and visible original failure.

Cache immutable or validated inputs by exact keys. Do not cache secrets, credentials, or mutable build outputs across trust boundaries. Ensure a cache miss preserves correctness.

Make required checks stable: avoid matrix job names that change unexpectedly and block branch rules. Explicitly define skipped-job behavior and ensure conditional paths cannot report success without performing required validation.

## Delivery controls

Separate continuous delivery (deployable artifact always ready) from continuous deployment (automatic production release). Use protected environments, separation of duties where required, change records, and promotion policies. A pipeline edit does not itself authorize executing a deployment.

Verify health after promotion and expose a safe rollback or roll-forward action. Database compatibility, feature flags, and irreversible operations need their own gates.

## Verification and reporting

Lint workflow syntax; run underlying commands locally where possible; inspect effective permissions; test failure, cancellation, fork, and missing-secret cases. Track queue time, duration, success, flakiness, artifact provenance, deployment frequency, lead time, failure rate, and recovery time without gaming metrics.

Report triggers, trust model, permission map, stages and gates, artifact identity/provenance, cache and concurrency semantics, commands/results, deployment authority, rollback path, and remaining risks.
