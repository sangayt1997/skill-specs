---
name: unit-testing
description: Create, improve, or review fast deterministic unit tests for meaningful behavior within a narrow module or component boundary. Apply when logic can be exercised without real network, database, process, or browser integration; avoid coupling tests to private implementation details.
---

# Unit Testing

Use unit tests to make local decisions, invariants, and failure behavior easy to understand and change safely.

## Workflow

1. Identify the public behavior, invariant, and smallest stable boundary under test.
2. Read nearby test conventions and production interfaces before choosing fixtures or doubles.
3. Enumerate representative, boundary, invalid, and failure cases; prioritize risks over line coverage.
4. Arrange minimal state, perform one meaningful action, and assert observable results or state.
5. Run the focused test, relevant suite, and static checks; inspect failure messages.
6. Refactor repeated setup only when the abstraction keeps scenarios readable.

## Guardrails

- Do not test private methods solely because they exist, reproduce implementation algorithms in expected values, or assert incidental call order.
- Do not use real network, shared databases, wall-clock sleeps, or global mutable state in unit tests.
- Do not mock value objects or stable pure collaborators merely to claim isolation.
- Keep production behavior intact; adding test-only branches to production code is usually a design smell.
- A passing unit test does not prove framework wiring, SQL behavior, serialization, or external compatibility.

## Select valuable cases

Test contracts and invariants: inputs to outputs, state transitions, emitted effects, validation, error taxonomy, and authorization decisions owned by the unit. Use boundary-value and equivalence-partition analysis. Include empty, minimum, maximum, malformed, duplicate, and relevant overflow/precision cases.

For algorithms with broad inputs, use table-driven and property-based tests. Record randomized seeds and shrink failures. Examples clarify recognizable cases; properties verify general invariants. Avoid exhaustive permutations with no distinct risk.

## Control dependencies

Inject or otherwise control nondeterministic boundaries such as clocks, randomness, IDs, scheduling, and external ports. Prefer small hand-written fakes or stubs with clear behavior. Use mocks when interaction itself is the contract—for example, an effect must not be emitted after rejection.

Keep mock expectations permissive about irrelevant details and strict about meaningful effects. Excessive mocking often signals that the unit boundary follows implementation rather than responsibility. If correctness depends on a dependency's real behavior, move that evidence to integration or contract tests.

## Structure and assertions

Give each test a behavior-oriented name. Keep setup local enough to understand, with builders that expose scenario differences. Assert complete important values rather than scattered weak predicates, but avoid unrelated assertions that obscure the failure cause.

For errors, assert stable type/code and relevant context rather than entire volatile messages or stack traces. For collections, state whether order matters. For floating point, use domain-appropriate tolerance. For time, use controlled clocks and explicit zones.

Snapshot tests are suitable only when the reviewed representation is the contract and diffs are comprehensible. Prefer semantic assertions for large or volatile structures.

## Determinism and maintainability

Tests must pass alone, in any order, and in parallel. Restore any process state changed by the test. Do not share mutable fixtures. Avoid arbitrary waits; drive completion through the abstraction's synchronization point.

Refactor tests when production behavior remains constant, and confirm mutation or fault injection is caught where the risk justifies it. Delete duplicate tests that provide no new confidence.

## Completion report

Report the behaviors and edge cases covered, doubles and controlled nondeterminism, focused and broader commands run, outcomes, known gaps requiring a different test layer, and any production design seam introduced.
