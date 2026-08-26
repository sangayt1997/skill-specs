---
name: dependency-security
description: Add, update, audit, replace, or remove third-party packages, build tools, actions, images, and transitive components using provenance, least dependency, vulnerability reachability, lockfiles, SBOMs, and controlled updates. Apply when software-supply-chain trust or component risk is material.
---

# Dependency Security

Minimize trusted third-party code and keep every accepted component identifiable, reproducible, reviewable, and updateable.

## Working method

1. Inventory direct and transitive runtime, development, build, workflow, container, and generated-code dependencies.
2. For a new component, define the needed capability and evaluate whether the standard library or existing dependency suffices.
3. Verify package identity, source repository, publisher/maintainers, release history, license, provenance, integrity, maintenance, and ecosystem fit.
4. Pin and lock according to ecosystem semantics; review resolved transitive changes and install/build scripts.
5. Scan through multiple relevant advisories, assess reachability and exposure, then remediate by risk and tested compatibility.
6. Record exceptions with owner, rationale, compensating controls, and expiry.

## Guardrails

- Never install or execute an unfamiliar package merely to inspect it; registry install hooks can execute code.
- Do not expose credentials to dependency installation, untrusted build steps, or pull-request workflows.
- A package name, download count, score, signature, or clean scanner result is not sufficient trust evidence alone.
- Do not blindly apply breaking upgrades or generated lockfile changes without reviewing behavior and tests.
- Preserve licenses and notices; flag incompatible or unclear terms rather than guessing.

## Evaluate trust and necessity

Prefer focused maintained components with a clear security policy, reachable maintainers, transparent source-to-artifact relationship, and timely releases. Investigate typosquatting, namespace ownership changes, sudden maintainership or provenance changes, suspicious scripts/binaries, excessive permissions, and dependency explosion.

Classify by execution and privilege: a build plugin or CI action can be more dangerous than a runtime library because it sees source and secrets. Browser packages reach users; parsers and network-facing libraries process hostile data; native code adds memory-safety risk. Scope review accordingly.

## Reproducibility and provenance

Commit supported lockfiles and use frozen/immutable installs in CI. Understand whether the lockfile includes integrity hashes and all platforms. Pin workflow actions and container bases to immutable revisions where appropriate while retaining an automated, reviewed refresh path.

Generate an SBOM for released artifacts when useful and keep source revision, builder identity, dependency graph, and artifact digest as provenance. Verify signatures/attestations only against an explicit trusted identity and policy.

## Vulnerabilities and updates

Deduplicate advisories by canonical identifier and affected version range. Confirm actual resolved version, platform, feature, call path, data exposure, privileges, and available exploit information. Scanner severity is an input; prioritize reachable remotely exploitable issues and critical build-chain compromise, while honoring organizational deadlines.

Preferred remediation order: remove the dependency, update to a fixed compatible version, disable the affected feature, replace the component, or apply a verified vendor patch. Compensating controls are temporary. If no fix exists, document exposure, monitoring, owner, deadline, and reconsidered acceptance.

Automate small frequent updates with required tests and human review for sensitive components. Test behavior, API compatibility, serialization, performance, licenses, generated assets, and platform matrices. Roll back by restoring the reviewed lockfile/artifact, not by guessing a version.

## Continuous controls

Protect registries and publisher accounts with strong authentication and minimal tokens. Separate read from publish credentials, use trusted publishing where available, restrict package sources, and prevent dependency confusion with explicit namespaces and registry policy.

Monitor new advisories, yanked releases, ownership changes, and end-of-life status. Define supported response and disclosure processes. Remove unused dependencies fully, including transitive overrides, configuration, licenses, caches, and credentials.

Report components and scope, trust/provenance evidence, dependency graph changes, advisories and reachability, chosen remediation, license findings, tests/scans run, exception expiry, and residual supply-chain risk.
