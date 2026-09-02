# Skill Authoring Standard

Write only guidance that materially improves an AI coding agent's decisions. Assume the agent already understands ordinary software engineering and tools.

## Preserve Intent and Context

- Preserve the user's requested product, scope, and authorization boundaries.
- Follow the target project's established stack and architecture unless changing them is part of the request.
- Do not turn one project's convention or one observed failure into a universal rule.
- State assumptions only when they materially affect the result.

## Make Guidance Actionable

- Describe the desired outcome, meaningful decision criteria, and real constraints.
- Explain when guidance applies and, where ambiguity is likely, when it does not.
- Prefer concrete checks over generic instructions such as “follow best practices.”
- Include verification proportional to the risk of the task.
- Keep workflows flexible when multiple approaches are valid.

Use normative terms deliberately:

- **MUST** for correctness, safety, compatibility, or required repository invariants.
- **SHOULD** for a strong default that may have justified exceptions.
- **MAY** for an optional technique or acceptable choice.

Do not use normative language merely for emphasis.

## Control Scope and Duplication

- Give each skill a cohesive responsibility and discriminating activation description.
- Check related skills before adding instructions that may belong elsewhere.
- Link to one authoritative rule instead of copying it across skills.
- Keep the complete skill self-contained in `SKILL.md`.
- Organize substantial conditional or mode-specific guidance into clearly labeled sections within the same file.

## Write Concisely

- Prefer plain language and short, direct sections.
- Remove generic tutorials, motivational prose, repeated rules, and speculative edge cases.
- Add examples only when they materially clarify a decision, boundary, or format.
- Do not add companion files, placeholder folders, or nested directories to a skill directory.

## Safety and External Effects

Instructions must not imply permission to broaden a user's task, disclose secrets, bypass safeguards, or perform unrelated external mutations. High-impact actions should identify the needed authorization and a stopping condition proportionate to their risk.

## Technology Scope

Keep guidance technology-independent where the engineering decision is general. Framework- or vendor-specific skills should activate only when that technology is actually in scope and should respect its current supported conventions.
