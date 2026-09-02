# Creating a Skill

Use this workflow:

1. Search existing skills and proposals for overlapping scope.
2. Open a proposal issue for a new skill or material scope change.
3. Choose the correct existing category.
4. Create a lowercase, kebab-case directory matching the skill name.
5. Copy [`templates/skill/SKILL.md`](../templates/skill/SKILL.md) into the directory.
6. Define valid frontmatter, clear activation boundaries, and actionable guidance.
7. Keep all instructions self-contained in that `SKILL.md`; the skill directory must contain no other files or subdirectories.
8. Record material external sources in the centralized [research references](research-references.md).
9. Review the skill against the repository authoring and quality standards.
10. Run `bash scripts/validate-skills.sh` before opening a pull request.

The normative requirements are defined in:

- [Skill specification](../specs/skill-specification.md)
- [Skill authoring standard](../specs/skill-authoring-standard.md)
- [Naming conventions](../specs/naming-conventions.md)
- [Quality standard](../specs/quality-standard.md)
