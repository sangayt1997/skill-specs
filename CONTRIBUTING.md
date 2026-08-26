# Contributing

Contributions to `skill-specs` are welcome.

By participating, you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## Before You Start

- Search existing skills, issues, and pull requests for related work.
- Open a skill proposal before implementing a new skill, new category, overlapping scope, or material format change.
- Use GitHub Discussions for exploratory questions that are not ready to become actionable issues.

Small corrections and focused improvements may go directly to a pull request.

## Development Workflow

1. Fork the repository and create a branch from the latest `main`.
2. Use a descriptive branch name such as `skill/caching`, `docs/authoring`, or `fix/validation`.
3. Make one focused change and update related documentation.
4. Run `bash scripts/validate-skills.sh`.
5. Review the complete diff for unrelated changes.
6. Open a pull request and complete the pull-request template.

Write clear commit messages that explain the change. Maintainers may squash commits when merging.

## Adding or Updating a Skill

- Put a skill at `skills/<category>/<skill-name>/SKILL.md`.
- Use a lowercase, kebab-case directory matching the YAML `name` exactly.
- Choose the most appropriate existing category. Propose new categories before creating them.
- Start from [`templates/skill/SKILL.md`](templates/skill/SKILL.md).
- Follow the [skill specification](specs/skill-specification.md), [authoring standard](specs/skill-authoring-standard.md), [naming conventions](specs/naming-conventions.md), and [quality standard](specs/quality-standard.md).
- Keep guidance technology-independent unless the skill intentionally targets a framework or vendor.
- Avoid duplicate or ambiguously overlapping responsibilities.
- Add supporting resources only when they materially improve repeated use of the skill.
- Record material external research in the centralized [research references](docs/research-references.md), preferring standards, primary research, and official documentation.

A planned placeholder must be clearly marked `**Status:** Planned`. A production-ready skill must contain actionable guidance and satisfy the complete quality checklist; removing `Planned` status is a substantive change requiring maintainer review.

## Pull-Request Expectations

A pull request should:

- explain the problem and rationale;
- link the relevant issue or proposal when applicable;
- remain focused enough to review confidently;
- preserve existing behavior outside its stated scope;
- include evidence or realistic examples for non-obvious rules; and
- pass required automated checks and Code Owner review.

Review comments are part of collaborative quality control. Resolve conversations only after addressing the feedback or documenting the agreed outcome.

AI-assisted contributions are welcome, but the contributor remains responsible for every submitted line. Disclose material AI assistance in the pull request and verify accuracy, licensing, safety, and consistency yourself.

## Licensing

By submitting a contribution, you agree that it may be distributed under this repository's [MIT License](LICENSE). Only submit material you have the right to license.

## Security

Do not open public issues for vulnerabilities, exposed secrets, or unsafe instructions with security impact. Follow [SECURITY.md](SECURITY.md).
