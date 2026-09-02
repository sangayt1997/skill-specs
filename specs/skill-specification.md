# Skill Specification

This document defines the repository contract for a valid skill file.

## Location

A repository skill must be stored at:

```text
skills/<category>/<skill-name>/SKILL.md
```

The directory name must match the skill's YAML `name`. The file must be named exactly `SKILL.md`.

## Single-File Contract

Each skill directory must contain exactly one file: `SKILL.md`. The file must be self-contained. Do not add companion references, scripts, assets, agent metadata, alternative entry points, or nested directories inside a skill directory.

Repository-level documentation, research bibliography, templates, examples, and validation tooling remain outside individual skill directories.

## Required Frontmatter

Every `SKILL.md` must begin with YAML frontmatter containing:

```yaml
---
name: example-skill
description: Guide AI coding agents to perform a specific task and explain when this skill should apply.
---
```

The `name` must satisfy the [naming conventions](naming-conventions.md). The `description` must distinguish both the skill's capability and intended activation scope. Do not place the full workflow in the description.

Supported optional frontmatter may be preserved when a target agent recognizes it, but optional fields must not make the core guidance unusable by other compatible agents.

## Body

A production-ready skill body must provide:

- purpose and useful activation boundaries;
- actionable instructions and material constraints;
- verification appropriate to the work;
- trade-offs or exceptions where rigid guidance could produce harm; and
- clear sections for substantial conditional or mode-specific guidance when needed.

Examples are optional. Include them only when they clarify a non-obvious decision or output.

## Status

Planned placeholders must contain `**Status:** Planned` and a concise intended scope. They must not imply that their detailed guidance is complete.

The reusable template uses `**Status:** Draft`, and illustrative examples use `**Status:** Example`. Production-ready skills do not need a status marker unless the repository later adopts explicit release metadata.

## Validation

Run:

```bash
bash scripts/validate-skills.sh
```

Automated validation checks structural invariants. Maintainer review determines whether the guidance is correctly scoped, actionable, safe, and worth maintaining.
