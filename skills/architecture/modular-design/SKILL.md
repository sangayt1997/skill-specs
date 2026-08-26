---
name: modular-design
description: Decompose software into cohesive modules with explicit ownership, hidden implementation decisions, stable contracts, and controlled dependency direction. Apply when creating or revising package, component, library, or subsystem boundaries; do not introduce process or service boundaries unless independently justified.
---

# Modular Design

Partition software so a meaningful change is usually localized, a module can be understood through its contract, and implementation decisions do not leak into unrelated code. A module may be a package, namespace, component, library, plugin, feature area, or internal subsystem; it does not need to be a separately deployed service.

Modularity is measured by change impact and dependency control, not by the number of folders, interfaces, or layers.

## Working Method

When designing or revising modules:

1. Identify responsibilities, business capabilities, invariants, data ownership, external integrations, and likely sources of change.
2. Map current dependencies and change coupling from imports, calls, schemas, tests, configuration, build rules, and repository history.
3. Group behavior that protects the same knowledge or changes for the same reason.
4. Choose each module's hidden decisions—data representation, algorithm, policy, integration mechanism, or lifecycle—and expose the smallest contract callers need.
5. Define allowed dependency direction, public entry points, ownership, and cross-module communication.
6. Test the proposed boundaries against realistic changes: determine which modules, tests, deployments, and teams would need modification.
7. Enforce boundaries with the language, build, lint, architecture-test, or repository mechanisms already available.
8. Migrate incrementally while preserving behavior and avoiding long-lived duplicate authorities.

Prefer evidence from actual change patterns over speculative reuse. A boundary that cannot explain what it protects is probably ceremony.

## Non-Negotiable Guardrails

- **MUST** give each module a cohesive responsibility and an identifiable owner for its contract and invariants.
- **MUST** keep internal representations, implementation dependencies, and volatile decisions behind the module boundary.
- **MUST** define and enforce dependency direction; diagrams and naming conventions alone are not boundaries.
- **MUST** preserve behavior, compatibility, security, transactionality, and data integrity while moving responsibilities.
- **MUST NOT** create a module solely because a file is large, a framework has a folder convention, or two functions look syntactically similar.
- **MUST NOT** introduce interfaces, factories, dependency injection, plugins, or shared packages without a current boundary or variability need.
- **MUST NOT** split an invariant across modules that can mutate it independently without defining coordination and ownership.
- **SHOULD** keep related behavior and data close enough that understanding or changing one does not require wide repository traversal.
- **SHOULD** prefer explicit, boring dependencies over hidden service locators, global registries, reflection, or ambient mutable state.
- **MAY** tolerate a documented boundary violation during migration when it is time-bounded, observable, and has one removal path.

## Decompose by Hidden Decisions

A strong module hides a design decision likely to change and exposes behavior that remains useful when that decision changes.

Potential hidden decisions include:

- storage schema and persistence technology;
- third-party protocol, SDK, or vendor behavior;
- parsing, calculation, matching, or scheduling algorithm;
- domain policy and state-transition rules;
- caching, batching, retry, or synchronization mechanism;
- serialization and compatibility details; and
- platform-specific or environment-specific behavior.

Avoid decomposing only by processing sequence—input, transform, output—when every feature change must touch every stage. Technical layers can be useful, but they should support change isolation rather than scatter one capability across unrelated owners.

Ask of each proposed module:

- What knowledge does it own?
- Which decisions may change without callers changing?
- Which invariants can it enforce locally?
- Who are its callers and what do they truly need?
- What would force coordinated changes across the boundary?

If the answers are broad or unrelated, the module is probably too large. If every caller must understand its internals, it is not hiding enough.

## Cohesion

Keep elements together when they collaborate to provide one capability, protect one invariant, own one lifecycle, or change for the same reason.

Signals of weak cohesion include:

- names such as `common`, `shared`, `utils`, `helpers`, `manager`, or `misc` containing unrelated behavior;
- a module with several independent owners or release reasons;
- configuration, initialization, and dependencies unrelated to most of its functions;
- many callers using disjoint subsets of the module; and
- changes to one responsibility repeatedly causing irrelevant tests or consumers to change.

Do not maximize cohesion by creating tiny modules with no meaningful contract. Navigation, build configuration, dependency wiring, and public API surface are real costs. Keep a small implementation local until it owns a stable concept or independent change pressure.

## Coupling

Minimize the knowledge modules require about one another, not all communication.

Review coupling through:

- source and build dependencies;
- shared database tables or files;
- shared mutable state and lifecycle;
- concrete types crossing boundaries;
- exception, event, and error semantics;
- configuration and environment variables;
- synchronized releases and migrations;
- test fixtures and mocks of internals; and
- team or ownership coordination required for routine changes.

Prefer semantic coupling through a narrow contract over structural coupling to another module's data representation. Pass purpose-specific values or types rather than exposing an entire persistence model, framework request, global context, or configuration object.

Do not eliminate direct calls merely to reduce an import count. An event bus, mediator, reflection layer, or generic command dispatcher can hide coupling from tools while making runtime behavior harder to trace.

## Contracts and Encapsulation

A module contract may include functions, types, events, commands, ports, schemas, or supported extension points. Keep it intentionally smaller and more stable than the implementation.

- Separate public, module-internal, and test-only surfaces using available language mechanisms.
- Expose behavior rather than getters and setters that let callers reconstruct internal policy.
- Validate inputs at the boundary that owns the contract and return domain-relevant outcomes.
- Avoid leaking storage entities, vendor exceptions, transport types, mutable collections, or internal identifiers unless they are deliberately part of the contract.
- Document preconditions, outputs, side effects, failure behavior, ordering, concurrency, lifecycle, and compatibility where non-obvious.
- Design invalid uses out of the contract when the type system can do so without disproportionate complexity.

Public APIs create long-term obligations. Do not export an internal symbol “just for reuse” when moving the caller or adding a purpose-specific operation would preserve encapsulation.

Friend, internal, or package-private access can support collaboration inside a module. If many external callers require exceptions to visibility, revisit the boundary rather than accumulating bypasses.

## Dependency Direction

Dependencies should point toward stable policies and contracts, not outward toward volatile details.

- Keep domain rules independent of UI, transport, database, framework, and vendor mechanisms when the application architecture benefits from that separation.
- Place integration adapters at the edge and translate to module-owned types.
- Let orchestration depend on capability contracts while implementations depend on infrastructure APIs.
- Keep dependency inversion proportional; a direct dependency is appropriate when the implementation is stable, local, and not a testing or ownership boundary.
- Prevent circular dependencies in source, build, initialization, and runtime communication.

Cycles mean the participating modules form one change and initialization unit. Break a cycle by moving shared policy to its true owner, inverting a dependency around a meaningful contract, merging modules that are not independent, or changing the workflow. Do not break it with a global registry or arbitrary interface that preserves the same conceptual cycle.

Define layering rules in terms of allowed knowledge. “Controller calls service calls repository” is insufficient if domain behavior leaks across every layer or lower layers call upward through hidden hooks.

## Data and State Ownership

A module should be authoritative for the state and invariants it owns.

- Mutate owned state only through the module's contract.
- Return immutable views, copies, iterators, or purpose-specific results when exposing a mutable representation would bypass invariants.
- Keep transaction boundaries aligned with invariants where possible.
- Make derived data explicitly rebuildable or reconcilable from its authority.
- Avoid modules that coordinate by modifying one another's tables, caches, or files directly.
- Define ownership of initialization, shutdown, cleanup, and background work.

Shared databases do not require shared ownership. Schema namespaces, access rules, repositories, and migration ownership can enforce module boundaries inside one deployment. Conversely, separate databases do not create good modules if every operation still requires cross-module coordination.

## Module Granularity

Choose granularity by cohesion, volatility, ownership, and interaction cost.

Split when:

- responsibilities have independent invariants or change drivers;
- one volatile detail repeatedly forces unrelated callers to change;
- a security, ownership, scaling, or lifecycle boundary needs enforcement;
- the public surface can be smaller than the combined implementation; or
- independent testing or replacement provides current value.

Merge when:

- modules always change and release together;
- their contracts mostly expose each other's internals;
- communication is chatty and preserves one invariant;
- an interface has only one permanent implementation and adds no boundary value; or
- ownership and lifecycle cannot be explained independently.

Do not use file count, line count, or class count as an architectural threshold. These can reveal symptoms but do not determine responsibility.

## Shared Code and Reuse

Reuse stable knowledge, not incidental similarity.

Before creating a shared module, determine:

- whether consumers mean the same thing by the behavior;
- who owns compatibility and release decisions;
- whether consumers need independent evolution;
- whether configuration or feature flags will turn the shared code into several hidden implementations; and
- whether duplication would actually drift or merely look alike.

Prefer duplicating a few obvious lines over coupling independent domain concepts. Consolidate when the copies represent one rule that must change consistently.

Keep shared foundational modules small and slow-changing. Because many modules depend on them, instability creates a wide blast radius. Avoid dependencies from foundational modules back into feature modules.

## Cross-Module Communication

Use the simplest communication style that preserves the required dependency and execution semantics.

- Direct calls are appropriate for synchronous local collaboration with clear ownership.
- Commands express an intent owned by the receiver.
- Events announce a completed fact and should not expose a producer's internal workflow.
- Queries return information without implying mutation unless explicitly documented.

Do not add in-process messaging to imitate a distributed architecture. It can obscure call paths and error propagation without providing independent deployment or failure isolation.

For asynchronous communication, define delivery, ordering, idempotency, transaction, schema evolution, and failure handling. An event name is not a substitute for a contract.

## Configuration and Composition

Compose modules at a visible application boundary.

- Keep environment and framework configuration out of core policies when practical.
- Validate configuration before starting dependent work.
- Pass only configuration a module owns rather than a global settings object.
- Make dependency lifetimes and sharing explicit.
- Keep optional modules and plugins isolated behind supported extension contracts.

Dependency injection is a means of composition, not a requirement for every class. Prefer constructor or parameter injection when it makes required dependencies and lifecycle visible. Avoid containers that allow arbitrary runtime lookup throughout the codebase.

## Testing Boundaries

Use tests to prove both behavior and modular independence.

- Unit-test module-owned policy through stable entry points where practical.
- Use contract tests for multiple implementations or independently evolving consumers and providers.
- Use integration tests at real persistence, transport, or framework adapters.
- Keep end-to-end tests for critical cross-module workflows, not every local branch.
- Avoid tests that reach through public boundaries to manipulate internals or mock long chains of collaborators.
- Add architecture tests or build rules for forbidden dependencies when regression risk justifies maintenance.

A module that can be tested only by booting the entire product may have hidden global state, lifecycle coupling, or a missing composition seam. Do not create artificial interfaces solely to make mocking easy; improve the real contract.

## Boundary Enforcement

Select enforcement available in the target ecosystem:

- compiler visibility, package or module systems, and separate build targets;
- dependency declarations and allowed-import rules;
- lint or static architecture checks;
- schema, database role, or filesystem ownership;
- code ownership and review routing; and
- API compatibility checks for published contracts.

Automate stable rules that prevent costly regressions. Do not encode every design preference into brittle dependency tests; exceptions and migration states need an explicit, reviewable mechanism.

Track useful evidence such as cyclic dependencies, public surface growth, forbidden imports, coordinated-change frequency, build fan-out, and test scope. Treat metrics as diagnostic signals, not targets to game.

## Incremental Refactoring

Change boundaries without combining the move with unnecessary behavior changes.

1. Characterize current behavior and external contracts with focused tests.
2. Introduce or clarify the destination contract.
3. Move one cohesive responsibility and redirect callers incrementally.
4. Keep one source of truth; use temporary forwarding adapters rather than duplicate business logic.
5. Add enforcement after enough migration has occurred to avoid freezing the wrong structure.
6. Remove obsolete paths, compatibility shims, and temporary exceptions when callers are migrated.

For larger migrations, record the desired dependency graph, ownership, milestones, compatibility strategy, and exit criteria. Avoid a “new architecture” that runs indefinitely beside the old one with bidirectional synchronization.

## Validation and Reporting

Before finishing:

1. Trace representative feature changes and verify they remain localized.
2. Inspect public surfaces and confirm internal representations do not leak.
3. Generate or inspect the dependency graph and check direction, cycles, and unexpected foundational fan-in.
4. Run module tests, contract tests, integration tests, and architecture checks according to the change risk.
5. Verify initialization, shutdown, error propagation, transactions, and configuration across boundaries.
6. Confirm the repository can build and test affected modules without undocumented global setup where modular independence requires it.
7. Review migration shims and boundary exceptions for owners and removal conditions.

Report material decisions in this form when useful:

```text
Module decision:
- Responsibility and owner:
- Hidden decisions:
- Public contract:
- Allowed dependencies:
- Data and lifecycle ownership:
- Enforcement:
- Migration and compatibility:
- Trade-offs and evidence:
```

Do not claim improved modularity from a new directory tree alone. Show how the design reduces knowledge, coordinated change, or invariant leakage.
