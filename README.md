# Skill Specs

> A collection of reusable AI skills and engineering specifications for building high-quality, scalable software.

`skill-specs` provides reusable engineering guidance for AI coding agents across core software engineering, frontend, backend, databases, architecture, quality and testing, security, and DevOps. Select the skill whose primary use best matches the task, then read its activation boundaries and instructions.

## Skills

| Domain | Skill | Primary use |
| --- | --- | --- |
| Core | [`algorithmic-efficiency`](skills/core/algorithmic-efficiency/SKILL.md) | Prevent avoidable computational, database, network, and scaling inefficiencies. |
| Core | [`clean-code`](skills/core/clean-code/SKILL.md) | Produce readable, cohesive, maintainable production code. |
| Core | [`code-review`](skills/core/code-review/SKILL.md) | Review code for prioritized, evidence-backed engineering risks. |
| Core | [`documentation`](skills/core/documentation/SKILL.md) | Create accurate task-oriented technical documentation. |
| Core | [`error-handling`](skills/core/error-handling/SKILL.md) | Design predictable failure, recovery, and error-reporting semantics. |
| Frontend | [`accessibility`](skills/frontend/accessibility/SKILL.md) | Build and review accessible web interfaces and interactions. |
| Frontend | [`anti-ai-slop`](skills/frontend/anti-ai-slop/SKILL.md) | Replace generic interface patterns with product-specific design decisions. |
| Frontend | [`frontend-architecture`](skills/frontend/frontend-architecture/SKILL.md) | Structure browser applications and cross-feature boundaries. |
| Frontend | [`frontend-performance`](skills/frontend/frontend-performance/SKILL.md) | Diagnose and improve measured user-perceived web performance. |
| Frontend | [`nextjs`](skills/frontend/nextjs/SKILL.md) | Implement version-appropriate Next.js applications. |
| Frontend | [`react`](skills/frontend/react/SKILL.md) | Implement and review React components, hooks, and state ownership. |
| Frontend | [`state-management`](skills/frontend/state-management/SKILL.md) | Model frontend state across UI, URL, server, and persistent stores. |
| Backend | [`api-design`](skills/backend/api-design/SKILL.md) | Design and evolve stable network API contracts. |
| Backend | [`authentication`](skills/backend/authentication/SKILL.md) | Establish and maintain caller identity securely. |
| Backend | [`authorization`](skills/backend/authorization/SKILL.md) | Define and enforce access-control policy. |
| Backend | [`backend-architecture`](skills/backend/backend-architecture/SKILL.md) | Structure server-side domains, services, data access, and jobs. |
| Backend | [`caching`](skills/backend/caching/SKILL.md) | Design caches with explicit freshness, invalidation, and failure behavior. |
| Backend | [`concurrency`](skills/backend/concurrency/SKILL.md) | Coordinate bounded concurrent work with safe ownership and cancellation. |
| Database | [`database-design`](skills/database/database-design/SKILL.md) | Model durable schemas, invariants, relationships, and data lifecycle. |
| Database | [`indexing`](skills/database/indexing/SKILL.md) | Design evidence-backed indexes from workloads and query plans. |
| Database | [`migrations`](skills/database/migrations/SKILL.md) | Evolve schemas and data through production-safe migrations. |
| Database | [`query-performance`](skills/database/query-performance/SKILL.md) | Diagnose and improve database workload performance. |
| Database | [`sql`](skills/database/sql/SKILL.md) | Write secure, correct, maintainable SQL and transactions. |
| Architecture | [`distributed-systems`](skills/architecture/distributed-systems/SKILL.md) | Design for partial failure, coordination, and distributed state. |
| Architecture | [`modular-design`](skills/architecture/modular-design/SKILL.md) | Create cohesive modules with controlled dependencies. |
| Architecture | [`scalability`](skills/architecture/scalability/SKILL.md) | Preserve service levels as traffic, data, and workload grow. |
| Architecture | [`system-design`](skills/architecture/system-design/SKILL.md) | Design systems from requirements through operations and evolution. |
| Quality | [`e2e-testing`](skills/quality/e2e-testing/SKILL.md) | Test critical outcomes through deployed system boundaries. |
| Quality | [`integration-testing`](skills/quality/integration-testing/SKILL.md) | Verify real component, infrastructure, and service interactions. |
| Quality | [`testing`](skills/quality/testing/SKILL.md) | Plan a risk-based testing strategy and quality gates. |
| Quality | [`unit-testing`](skills/quality/unit-testing/SKILL.md) | Test meaningful behavior within narrow deterministic boundaries. |
| Security | [`api-security`](skills/security/api-security/SKILL.md) | Protect exposed API data, operations, resources, and business flows. |
| Security | [`dependency-security`](skills/security/dependency-security/SKILL.md) | Manage dependency and software-supply-chain risk. |
| Security | [`secure-coding`](skills/security/secure-coding/SKILL.md) | Implement code safely across trust and sensitive-data boundaries. |
| DevOps | [`ci-cd`](skills/devops/ci-cd/SKILL.md) | Build secure, reproducible integration and delivery pipelines. |
| DevOps | [`deployment`](skills/devops/deployment/SKILL.md) | Release immutable artifacts with controlled exposure and recovery. |
| DevOps | [`docker`](skills/devops/docker/SKILL.md) | Build secure, minimal, reproducible container images. |
| DevOps | [`observability`](skills/devops/observability/SKILL.md) | Design actionable metrics, logs, traces, profiles, and alerts. |

Skills are stored at `skills/<category>/<skill-name>/SKILL.md`.

## Repository Structure

- `skills/` — skills grouped by engineering domain
- `specs/` — format, authoring, naming, and quality standards
- `docs/` — usage, compatibility, creation, contribution guidance, and [research references](docs/research-references.md)
- `templates/` — reusable skill starter templates
- `examples/` — small illustrative skill packages
- `scripts/` — repository validation utilities

## Contributing

Contributions are welcome through pull requests. Start with [CONTRIBUTING.md](CONTRIBUTING.md), follow the [skill specification](specs/skill-specification.md), and use the provided [skill template](templates/skill/SKILL.md).

Run the repository checks before opening a pull request:

```bash
bash scripts/validate-skills.sh
```

For questions, use GitHub Discussions. Report security concerns privately according to [SECURITY.md](SECURITY.md).

## Community and Governance

- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Governance](GOVERNANCE.md)
- [Support](SUPPORT.md)
- [Security policy](SECURITY.md)

## License

This repository is available under the [MIT License](LICENSE).
