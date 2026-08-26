---
name: documentation
description: Create and maintain accurate, task-oriented technical documentation, including READMEs, tutorials, how-to guides, references, API contracts, architecture records, runbooks, docstrings, and code comments. Apply when users or maintainers need durable guidance; avoid duplicating clearer authoritative sources.
---

# Documentation

Help a defined reader accomplish a task, understand a system, or rely on a contract. Prefer a small set of accurate, discoverable documents over exhaustive prose that cannot be maintained. Treat documentation changes as part of the product change that made them necessary.

Documentation is durable system behavior for humans. Do not use it to compensate for a misleading API, unsafe default, unclear code, or broken workflow when those can reasonably be corrected at the source.

## Working Method

Before writing or changing documentation:

1. Identify the audience, their starting knowledge, the question or task, and the point at which they encounter the document.
2. Inspect the implementation, tests, schemas, configuration, generated references, release policy, and existing documentation. Establish the authoritative source for each factual claim.
3. Choose the document mode: tutorial, how-to guide, reference, explanation, or a clearly structured combination for a small page.
4. Put the content at the location readers are likely to discover and maintain alongside the behavior it describes.
5. Write the shortest complete path for the primary use case, then add prerequisites, alternatives, edge cases, and deeper context according to reader need.
6. Verify commands, examples, links, version claims, and navigation against the current project.
7. Review the rendered result and source for clarity, accessibility, portability, and future maintenance.

Ask for missing facts only when they cannot be established from project evidence and guessing would create misleading instructions.

## Non-Negotiable Guardrails

- **MUST** keep documentation consistent with the current implementation, supported versions, configuration, and user-visible behavior.
- **MUST** distinguish verified behavior from proposals, assumptions, historical context, and future plans.
- **MUST** update affected documentation in the same change as the behavior whenever practical.
- **MUST NOT** invent commands, outputs, performance results, compatibility, guarantees, defaults, environment variables, or recovery steps.
- **MUST NOT** publish secrets, real credentials, personal data, private endpoints, exploitable security details, or unsafe copy-paste examples.
- **MUST NOT** duplicate an authoritative source when a durable link and short local context are sufficient.
- **SHOULD** optimize for the reader's task and time to a correct outcome, not for demonstrating the author's knowledge.
- **SHOULD** remove or redirect obsolete documentation instead of leaving contradictory copies.
- **MAY** document a known limitation or workaround rather than expanding the implementation scope, provided ownership, applicability, and exit conditions are clear.

## Choose the Right Document Type

Do not mix incompatible reader goals without structure.

### Tutorial

A tutorial is a learning-oriented, guided experience. It should:

- state what the reader will build or learn;
- define prerequisites and provide a known-good path;
- use a small, reliable scenario with visible progress;
- explain only what is needed for the next step; and
- end with a working result and clear next steps.

Do not turn a tutorial into an exhaustive option reference. Avoid unexplained leaps, optional branches in the main path, and examples that require hidden setup.

### How-To Guide

A how-to guide helps a competent reader complete a specific real-world task. It should:

- use a task-oriented title;
- state prerequisites, permissions, scope, and expected outcome;
- present actions in execution order with decision points and verification;
- include safety warnings before irreversible or disruptive steps; and
- cover recovery or rollback when failure has meaningful cost.

Keep conceptual teaching brief and link to explanation or reference material when needed.

### Reference

Reference documentation describes a contract accurately and predictably. It should:

- mirror the structure and vocabulary of the system;
- document types, parameters, defaults, constraints, units, return values, errors, side effects, and lifecycle;
- state version, stability, deprecation, and compatibility information where relevant;
- use consistent headings and field order; and
- favor generated content when the machine-readable source is authoritative, while reviewing generated quality.

Reference material should support lookup, not require linear reading. Do not bury normative behavior inside a tutorial narrative.

### Explanation

Explanation helps readers understand why a system works as it does. It may cover architecture, concepts, trade-offs, history, alternatives, and mental models.

Separate current constraints from historical decisions. Link claims to design records, requirements, measurements, or standards where those sources matter. Do not present one implementation as universally correct.

## Information Architecture and Discovery

Place each fact where its owner can keep it accurate.

- Use a root README to orient newcomers: purpose, status, quickest valid entry point, major directories or components, validation, contribution, support, security, and links to deeper material.
- Use package or component documentation for local contracts, ownership, development, testing, and debugging information.
- Keep user tasks near user documentation and operator procedures near the systems and alerts they govern.
- Record architectural decisions where future maintainers will find them, including context, decision, consequences, status, and superseding decisions.
- Keep a canonical source for shared facts. Link to it rather than synchronizing copies manually.
- Provide navigation from general orientation to task guidance, reference, and deeper explanation.

Do not add a README to every directory mechanically. Add one where it materially improves orientation or ownership and does not compete with an established documentation entry point.

## Writing and Structure

Write for scanning first and careful reading second.

- Lead with the outcome or purpose, then prerequisites and details.
- Use descriptive, unique headings in a logical hierarchy with one page title.
- Put one primary idea in each paragraph and important distinguishing information early.
- Prefer direct, active language. Address the reader consistently; start procedural steps with an imperative verb.
- Define unfamiliar terms and acronyms at first use. Use one term per concept.
- Use lists for sequences or comparable items, tables only for relationships that are genuinely easier to scan in rows and columns, and prose for reasoning.
- Keep warnings specific: name the hazard, conditions, consequence, and safe action.
- Avoid vague references such as “above,” “below,” “simply,” “obviously,” and “click here.”
- Preserve official product names, capitalization, UI labels, code identifiers, and domain vocabulary.

Match the repository's style and formatter. Do not impose a universal line length, heading capitalization, or tone when the project already defines one.

## Procedures, Commands, and Examples

Examples are part of the contract readers will copy.

- Use the project's current public APIs and recommended approach.
- Provide the smallest realistic example that demonstrates the intended behavior without hiding important setup.
- Separate commands, source code, configuration, and output; label fenced code blocks with the correct language when supported.
- Make placeholders unmistakable and explain where values come from.
- Avoid prompts or commentary inside copyable command blocks unless project convention supports them.
- Quote paths and values correctly for the stated shell or platform.
- State the working directory and environment when they affect success.
- Show expected output only when it helps verification, and keep nondeterministic values clearly illustrative.
- Use safe, non-production defaults. Put destructive commands behind an explicit warning, backup or recovery guidance, and confirmation boundary.
- Prefer examples that can be compiled, executed, or tested automatically.

If an example is intentionally abbreviated, mark the omission and ensure it does not remove error handling, authorization, cleanup, or another property that readers must preserve.

## API and Contract Documentation

Document what a caller can rely on rather than narrating the implementation.

For applicable interfaces, cover:

- purpose and appropriate use;
- inputs, types, units, ranges, encoding, nullability, and defaults;
- outputs and ownership or lifecycle expectations;
- authentication, authorization, and permission requirements;
- errors or status outcomes and whether retry is safe;
- side effects, idempotency, ordering, consistency, and concurrency behavior;
- pagination, rate limits, timeouts, and resource limits;
- compatibility, stability, deprecation, and migration; and
- one minimal correct example for non-obvious usage.

Keep generated API documentation anchored to source annotations or schemas. Correct the authoritative source rather than patching generated output unless the repository explicitly requires checked-in generated artifacts.

## Architecture and Decision Documentation

Architecture documentation should help maintainers predict change impact.

Include the system boundary, responsibilities, major components, dependency direction, data ownership, trust boundaries, key data or request flows, external integrations, deployment topology when relevant, and important quality trade-offs.

Use diagrams only when they communicate relationships more clearly than prose. Provide labels, a textual explanation, and the relevant scope or version. Keep diagrams close to an editable source and avoid unexplained screenshots.

Decision records should capture:

- the problem and constraints at the time;
- the chosen decision and status;
- viable alternatives considered;
- positive and negative consequences; and
- links to superseding decisions when the choice changes.

Do not rewrite historical records to make them appear current. Mark them superseded and link forward.

## Operational Documentation

Runbooks must support action under pressure. Include:

- trigger conditions and symptoms;
- required access, tools, and safety constraints;
- diagnostic steps that distinguish likely causes;
- mitigation in a safe order with stop conditions;
- verification of recovery;
- rollback or escalation paths; and
- follow-up evidence to preserve.

Do not promise that a procedure is safe unless its permissions, blast radius, failure modes, and recovery have been established. Avoid embedding short-lived hostnames, credentials, or individual contact details when maintained service discovery or ownership systems exist.

## Code Comments and Docstrings

Use names and structure to explain what code does. Use comments for information code cannot preserve clearly:

- rationale and rejected simpler alternatives;
- external constraints, standards, protocols, or compatibility workarounds;
- invariants and non-obvious ownership or concurrency rules; and
- consequences that make an apparently safe edit dangerous.

Docstrings and public symbol documentation describe the caller-facing contract: purpose, meaningful inputs and outputs, side effects, errors, lifecycle, and non-obvious usage.

Do not narrate syntax, duplicate a signature, leave disabled code in comments, or explain confusing code only in a review discussion. Clarify the code first; add a comment when essential context still cannot be expressed.

## Versioning, Deprecation, and Migration

Make applicability explicit when multiple versions are in use.

- State the version in which behavior was introduced, changed, deprecated, or removed when readers need it.
- Keep examples aligned with the documented version.
- Explain the replacement, migration steps, compatibility window, and removal timeline for deprecations.
- Do not silently update old release documentation to describe new behavior.
- Distinguish forward migration, rollback, and irreversible transitions.

Use one durable versioning strategy rather than scattering ad hoc badges and warnings across pages.

## Accessibility and Inclusion

- Use meaningful link text that makes sense out of context.
- Provide alt text that communicates the purpose of informative images; use empty alt text for purely decorative images when the format supports it.
- Do not use color, position, emoji, or an image alone to convey required information.
- Use real headings in order and avoid skipped levels chosen only for visual size.
- Keep tables simple, introduce what they compare, and provide text alternatives for complex visuals.
- Prefer clear global English, avoid unnecessary idiom, and use inclusive examples and names.

Consider localization: avoid embedding words inside images, concatenating translatable fragments, or relying on culture-specific formats without explanation.

## Maintenance and Validation

Before finishing:

1. Verify factual claims against code, tests, schemas, configuration, or an authoritative external source.
2. Run documented commands and examples in the stated environment when practical.
3. Build or preview the documentation and check headings, lists, tables, code fences, images, and navigation.
4. Run repository formatting, linting, link, spelling, and example tests when available.
5. Check internal and external links, anchors, redirects, and version targets.
6. Search for conflicting or now-obsolete documentation and update, redirect, or remove it.
7. Review the diff for accidental secrets, private data, unsafe commands, stale screenshots, and unrelated rewrites.

If a command or example could not be verified, state that limitation. Report material documentation changes and any remaining source-of-truth or compatibility uncertainty; do not claim completeness merely because every heading is populated.
