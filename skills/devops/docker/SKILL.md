---
name: docker
description: Create, optimize, harden, or review Dockerfiles, build contexts, container images, and Docker-based development flows for reproducibility, minimal attack surface, correct runtime behavior, and efficient caching. Apply when container build or execution is central; verify target platform and runtime constraints.
---

# Docker

Produce a small, reproducible runtime image that contains only what the application needs.

## Workflow

1. Inspect application build/run commands, native dependencies, target CPU/OS, runtime filesystem needs, ports, signals, and existing orchestration.
2. Choose a trusted maintained base compatible with required libc, certificates, timezone, and debugging needs.
3. Separate dependency, build, test, and runtime stages; copy only runtime artifacts into the final stage.
4. Minimize build context with `.dockerignore` and arrange stable dependency layers before frequently changing source.
5. run as a non-root user with explicit work directory, entrypoint/command, and writable paths.
6. Build cleanly, inspect history/config, run tests, scan, and verify startup, shutdown, and target architecture.

## Security guardrails

- Never place credentials in `ARG`, `ENV`, copied files, image layers, or build logs. Use supported secret mounts and runtime secret delivery.
- Do not copy the repository wholesale before reviewing sensitive and irrelevant files.
- Use trusted bases and immutable digests where reproducibility requires them; keep a controlled process to refresh security patches.
- Remove compilers, package managers, shells, and caches from runtime unless operationally required.
- Run without root where feasible; drop capabilities, use read-only filesystems, and prevent privilege escalation at deployment.
- Scanning informs risk but does not prove exploitability or safety; triage findings against reachable contents and update policy.

## Dockerfile design

Pin application dependencies with ecosystem lockfiles. Combine package-index refresh and installation in the same layer where relevant, install only required packages, and remove caches. Use multi-stage builds to avoid leaking build tooling or secrets.

Use `COPY` rather than `ADD` unless archive extraction or remote-source semantics are explicitly wanted and reviewed. Use exec-form entrypoints so the application receives signals. If a wrapper is necessary, it should use strict error handling and replace itself with the application process.

Declare health checks only when the deployment platform uses them meaningfully; a Dockerfile health check is not a substitute for orchestration readiness. Do not bake environment-specific configuration into a reusable artifact.

## Runtime behavior

Containers should tolerate replacement and store durable state in explicit external volumes or services. Define writable paths, temporary storage, UID/GID expectations, file ownership, certificates, locale, timezone, and memory/CPU behavior. Handle PID 1 signal forwarding and zombie reaping where child processes exist.

Do not assume `localhost` reaches sibling containers. Use named networks and service discovery. Avoid binding development services publicly unless requested.

## Build quality

Use cache mounts only when a clean build remains correct. Support deterministic multi-platform builds when required and verify native dependencies. Attach labels, source revision, SBOM, and provenance according to the release process. Rebuild regularly so immutable images include maintained dependencies.

Test with an empty external environment, non-root execution, read-only root where targeted, expected mounts, a clean build context, graceful termination, health behavior, and representative resource limits. Report base/digest strategy, stages, user and permissions, secrets handling, size, scan/test results, platforms, runtime assumptions, and update path.
