---
name: clean-code
description: Produce and refactor readable, maintainable production code with clear names, cohesive responsibilities, explicit data flow, and proportionate abstraction. Apply during implementation or structural improvement, but not as justification for unrelated cosmetic rewrites.
---

# Clean Code

Optimize code for the next engineer who must understand, change, test, debug, or operate it. Prefer the simplest structure that expresses the required behavior and fits the repository's established language, framework, architecture, and formatting conventions.

Clean code is not a particular aesthetic. It is code whose intent, invariants, dependencies, side effects, and failure behavior can be understood with reasonable local context.

## Working Method

When implementing or refactoring:

1. Establish the required behavior, public contracts, compatibility constraints, and likely future change points from repository evidence.
2. Inspect nearby code, tests, types, formatters, linters, and naming conventions before choosing a structure.
3. Model the domain concepts, data flow, ownership, state transitions, side effects, and failure paths explicitly.
4. Implement the smallest coherent design that satisfies the requirement without speculative layers.
5. Read the result as an unfamiliar maintainer: trace the main path, exceptional paths, inputs, outputs, and mutations.
6. Remove accidental complexity and duplication introduced by the change, then validate behavior with the project's normal checks.

Keep reasoning proportional. A small local change does not require redesigning its subsystem.

## Non-Negotiable Guardrails

- **MUST** preserve observable behavior, contracts, security properties, error semantics, ordering, concurrency assumptions, and data integrity unless the task explicitly changes them.
- **MUST** follow repository-owned formatting, linting, typing, generated-code, and architectural conventions when they exist.
- **MUST** make important side effects, state changes, ownership, and external interactions discoverable at the relevant call site or boundary.
- **MUST NOT** combine an unrelated rename, reformat, dependency change, or broad cleanup with a focused behavioral change.
- **MUST NOT** introduce an abstraction solely to remove superficial repetition or anticipate an unconfirmed future requirement.
- **MUST NOT** hide unclear behavior behind comments, generic helpers, catch-all types, or misleading names.
- **SHOULD** optimize for clarity, then simplicity, then concision; short code is not automatically clear code.
- **SHOULD** leave changed code at least as understandable and maintainable as before.
- **MAY** retain a locally imperfect pattern when changing it would expand scope or risk; avoid making the pattern more entrenched and note material follow-up work.

## Names and Vocabulary

Choose names that communicate domain meaning and role at the point of use.

- Use the repository's terminology consistently. Do not introduce synonyms for the same concept without a domain reason.
- Name functions for the behavior they provide and values for what they represent, including units or state when ambiguity is realistic.
- Make booleans read as predicates and avoid boolean parameters whose meaning is unclear at the call site; prefer a named option or distinct operation when it improves the contract.
- Avoid vague names such as `data`, `item`, `value`, `manager`, `helper`, `util`, `process`, or `handle` when a more precise responsibility is known.
- Avoid encoding a type, implementation detail, or temporary mechanism in a name when the abstraction is expected to outlive it.
- Keep short conventional names for tiny, obvious scopes; use more context as scope and ambiguity grow.

Do not rename established public vocabulary casually. A locally clearer name may still be wrong if it breaks compatibility or conflicts with the domain language.

## Functions and Control Flow

Give each function one coherent responsibility at one useful level of abstraction. “One responsibility” means one reason to change, not one statement or an arbitrary line limit.

- Keep inputs, outputs, mutations, and failure modes explicit.
- Prefer returning a result over modifying distant or hidden state when the project's design permits.
- Separate orchestration from detailed computation when mixing them obscures the main flow.
- Use early returns or guard clauses when they make preconditions and exceptional paths clearer; do not force them when a single structured branch is easier to follow.
- Replace deeply interleaved conditions with named predicates, explicit state transitions, lookup tables, or polymorphism only when the alternative is genuinely clearer.
- Handle all meaningful variants. Use exhaustive constructs where supported, and make intentionally ignored cases explicit.
- Avoid flag combinations and sentinel values that permit invalid or ambiguous states when the type system or data model can represent the distinction directly.
- Keep resource acquisition, use, and cleanup visibly paired through the language's structured mechanisms.

Extract a function when its name explains a meaningful concept, it isolates a reusable policy, it reduces duplicated knowledge, or it creates a useful testing or change boundary. Do not extract trivial indirection that forces readers to jump between files without gaining meaning.

## Modules, Boundaries, and Dependencies

Organize code around cohesive responsibilities and stable contracts.

- Keep domain policy separate from transport, persistence, framework, or presentation details when the existing architecture supports that boundary.
- Pass dependencies explicitly enough that ownership, lifecycle, and test substitution remain understandable.
- Minimize knowledge across modules: expose what callers need, preserve invariants behind the boundary, and avoid leaking internal representations.
- Keep public APIs smaller and more stable than internal implementation details.
- Avoid circular dependencies, shared mutable globals, service-locator access, and “common” modules that accumulate unrelated behavior.
- Place behavior near the data or policy it governs unless doing so would violate an established layer boundary.

Do not add interfaces, factories, repositories, wrappers, or configuration points merely because they might be useful later. Introduce a boundary when there are current consumers, meaningful volatility, external integration concerns, or test seams that justify its cost.

## Data, State, and Invariants

Make valid states easy to create and invalid states difficult to represent.

- Validate inputs at the boundary that owns the contract, then operate on a trustworthy internal representation.
- Represent distinct domain concepts with distinct types or structures when confusing them could cause realistic defects.
- Keep state minimal and derive values when derivation is cheap, deterministic, and does not create competing sources of truth.
- Limit mutation to the smallest practical scope and make ownership of mutable state clear.
- Preserve units, precision, encoding, time zones, nullability, ordering, and identity semantics explicitly where they matter.
- Use collections and data structures according to their semantic requirements, not only convenience.

Avoid defensive checks that contradict established invariants or conceal upstream defects. Enforce the invariant at its owner and fail predictably when it is violated.

## Abstraction and Duplication

Apply “do not repeat yourself” to duplicated knowledge, not merely similar syntax.

Unify code when copies must change together because they encode the same rule. Keep code separate when the resemblance is incidental, the concepts evolve independently, or a shared abstraction would require flags and conditional behavior for unrelated callers.

Before introducing or expanding an abstraction, check:

- Does it have one describable purpose?
- Is its contract smaller and more stable than the implementations it hides?
- Does it reduce the context needed by callers?
- Can it represent current variation without boolean modes, downcasts, or leaky escape hatches?
- Is the added navigation, configuration, and testing cost justified?

Prefer a small amount of obvious duplication over the wrong shared abstraction. When a pattern has not stabilized, let evidence accumulate before generalizing it.

## Comments and Documentation

Code should express what it does. Comments should preserve information the code cannot express clearly, such as:

- why a non-obvious constraint or workaround exists;
- which invariant, protocol, compatibility issue, or external decision governs the code;
- why an apparently simpler alternative is unsafe; or
- what a deliberate performance or operational trade-off protects.

Keep comments adjacent to the behavior they explain and update or remove stale comments in the changed area. Do not narrate syntax, duplicate names, preserve dead code, or use a comment as a substitute for clarifying confusing code.

Document public contracts according to project conventions: purpose, inputs, outputs, side effects, failure behavior, units, lifecycle, and non-obvious usage constraints. Do not restate information already enforced and clearly expressed by types or signatures.

TODOs must be actionable and follow repository policy, ideally with an owner or tracking reference and the condition for removal. Never use a TODO to silently defer correctness or security required by the current task.

## Change Hygiene

Keep changes reviewable and reversible.

- Separate mechanical transformations from behavioral changes when practical.
- Remove dead code only when its lack of use is established; account for reflection, configuration, serialization, plugins, generated callers, and external consumers.
- Preserve backward compatibility unless the task authorizes a breaking change and the migration is handled.
- Do not hand-edit generated artifacts without changing their source or following the repository's generation workflow.
- Avoid new dependencies for behavior the existing stack can express clearly and safely.
- Update tests and documentation that encode the changed contract, not every nearby artifact indiscriminately.

## Validation

Validate the code at the narrowest useful level, then broaden according to risk:

1. Run the repository formatter, linter, type checker, and relevant static analysis.
2. Run focused tests for changed behavior, boundaries, and failure paths.
3. Run broader tests when shared contracts, public APIs, data models, configuration, or cross-module behavior changed.
4. Inspect the diff for accidental churn, stale names or comments, hidden behavior changes, and unnecessary abstraction.
5. Re-read important call sites to ensure the resulting API is harder to misuse and no more difficult to understand.

Do not claim improved maintainability solely because code became shorter or used a fashionable pattern. Report material structural decisions, compatibility implications, and unresolved trade-offs; omit routine cosmetic detail.
