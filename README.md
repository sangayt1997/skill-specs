# Skill Specs

> A collection of reusable AI skills and engineering specifications for building high-quality, scalable software.

`skill-specs` provides reusable engineering guidance for AI coding agents across core software engineering, frontend, backend, databases, architecture, quality and testing, security, and DevOps.

The repository is built incrementally. Skills marked **Planned** define an intended scope but do not yet contain complete production guidance.

## Implementation Status

The repository currently contains **15 implemented skills** and **22 planned skills**.

### Implemented

- **Core:** [`algorithmic-efficiency`](skills/core/algorithmic-efficiency/), [`clean-code`](skills/core/clean-code/), [`code-review`](skills/core/code-review/), [`documentation`](skills/core/documentation/), and [`error-handling`](skills/core/error-handling/)
- **Architecture:** [`distributed-systems`](skills/architecture/distributed-systems/), [`modular-design`](skills/architecture/modular-design/), [`scalability`](skills/architecture/scalability/), and [`system-design`](skills/architecture/system-design/)
- **Frontend:** [`accessibility`](skills/frontend/accessibility/), [`frontend-architecture`](skills/frontend/frontend-architecture/), [`frontend-performance`](skills/frontend/frontend-performance/), [`nextjs`](skills/frontend/nextjs/), [`react`](skills/frontend/react/), and [`state-management`](skills/frontend/state-management/)

### In Progress and Planned

The next implementation areas currently retain planned specifications:

- **Backend:** API design, authentication, authorization, backend architecture, caching, and concurrency
- **Database:** database design, indexing, migrations, query performance, and SQL
- **Quality:** end-to-end testing, integration testing, testing strategy, and unit testing
- **Security:** API security, dependency security, and secure coding
- **DevOps:** CI/CD, deployment, Docker, and observability

This section reflects the status declared by each skill. A planned skill is not considered implemented until its production guidance replaces the placeholder and passes repository validation.

## Browse the Skills

Skills are grouped under [`skills/`](skills/) by engineering domain:

- `core` — broadly applicable engineering practices
- `frontend` — browser and user-interface engineering
- `backend` — services, APIs, identity, caching, and concurrency
- `database` — data modeling, SQL, indexing, queries, and migrations
- `architecture` — modularity, system design, scalability, and distribution
- `quality` — testing strategy and test levels
- `security` — secure implementation, APIs, and dependencies
- `devops` — integration, delivery, containers, observability, and deployment

Each skill is stored at `skills/<category>/<skill-name>/SKILL.md`.

## Repository Structure

- `skills/` — skills grouped by engineering domain
- `specs/` — format, authoring, naming, and quality standards
- `docs/` — usage, compatibility, creation, and contribution guidance
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
