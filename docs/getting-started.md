# Getting Started

`skill-specs` is a collection of reusable engineering guidance for AI coding agents. Begin with the [skills catalog](../README.md#skills), choose the entry whose primary use matches the task, and read its linked `SKILL.md` for activation boundaries and instructions.

Skills are grouped under [`skills/`](../skills/) by engineering domain. Each skill is represented by exactly one self-contained `SKILL.md`, and the catalog links to every skill included in repository validation.

To contribute, read the root [contribution guide](../CONTRIBUTING.md), the [skill specification](../specs/skill-specification.md), and the [authoring standard](../specs/skill-authoring-standard.md). New skills should begin with the [reusable template](../templates/skill/SKILL.md).

Validate a contribution locally with:

```bash
bash scripts/validate-skills.sh
```
