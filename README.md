# skill-specs

> A collection of reusable AI skills and engineering specifications for building high-quality, scalable software.

`skill-specs` provides reusable engineering guidance for AI coding agents across core software engineering, frontend, backend, databases, architecture, quality and testing, security, and DevOps.

The repository is built incrementally. Skills marked **Planned** define an intended scope but do not yet contain complete production guidance.

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
