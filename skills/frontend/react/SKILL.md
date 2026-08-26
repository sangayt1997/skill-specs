---
name: react
description: Implement, refactor, debug, or review React components and hooks using pure rendering, explicit state ownership, correct effects, stable identity, composition, concurrency, and measured optimization. Apply to React-specific UI behavior; defer routing, server rendering, and data-cache semantics to the active framework.
---

# React

Write React as a declarative description of UI from props, state, and context. Keep rendering pure, state minimal, events explicit, and Effects limited to synchronization with systems outside React.

Inspect the installed React version, renderer, framework, compiler configuration, lint rules, and existing conventions before selecting APIs. React DOM, React Native, Server Components, Actions, and framework integrations do not share every capability.

## Working Method

1. Reproduce the user-visible behavior and inspect the component tree, state owners, effects, context, and external systems.
2. Identify the minimal UI states, events, derived values, and authoritative source for each datum.
3. Define component responsibilities and accessible semantic output before introducing hooks or abstraction.
4. Keep render pure; place interaction consequences in event handlers and external synchronization in focused Effects.
5. Preserve identity deliberately with stable keys and component positions.
6. Profile before adding memoization, transitions, deferred values, or virtualization.
7. Test behavior through the rendered UI, including errors, pending work, cleanup, remounting, and accessibility.
8. Run the repository's lint, type, test, and production-build checks appropriate to the change.

Do not replace the project's state library, framework data layer, component system, or compiler setup unless requested or clearly required by the scoped task.

## Non-Negotiable Guardrails

- **MUST** keep Components and Hooks pure and idempotent during render.
- **MUST** treat props and state as immutable snapshots and update through supported setters or dispatch.
- **MUST** call Hooks only at the top level of React Components or custom Hooks, except APIs whose installed-version contract explicitly permits other use.
- **MUST** include every reactive dependency used by an Effect; change the code rather than suppressing the dependency rule.
- **MUST** clean up subscriptions, timers, observers, requests, widgets, and other external resources symmetrically.
- **MUST NOT** call component functions directly instead of rendering JSX.
- **MUST NOT** copy props into state or store derived values without a lifecycle reason.
- **MUST NOT** use array indexes, random values, or regenerated identifiers as keys for reorderable or stateful lists.
- **MUST NOT** add `memo`, `useMemo`, or `useCallback` by default or claim a performance gain without profiling.
- **SHOULD** preserve native HTML semantics and accessibility rather than rebuilding platform controls.

## Components and Responsibilities

A component should represent one understandable UI responsibility. Keep related markup, interaction, and local state together. Split when a child has independent behavior, reuse, expensive rendering, or a clearer ownership boundary; do not split every wrapper into a component.

Prefer composition:

- pass content through `children` or explicit slots;
- pass values and intent callbacks through purposeful props;
- keep domain-specific composition in feature components; and
- use specialized variants instead of large components controlled by many unrelated flags.

Make illegal combinations hard to express. For reusable components, define controlled/uncontrolled behavior, naming and semantic requirements, supported states, ref behavior, and composition limits. Do not leak internal setters or mutable objects as the public API.

Keep component definitions at module scope. Defining a component inside another component gives it a new type each render and can reset its state unexpectedly.

## Pure Rendering

Given the same props, state, and context, render must return the same result without observable side effects.

During render:

- do not mutate props, state, context, module globals, caches, DOM, or values already passed to JSX;
- do not subscribe, start timers, send analytics, perform mutations, or imperatively navigate;
- do not depend directly on changing ambient values such as current time or randomness when stability matters;
- create new derived arrays and objects instead of mutating inputs; and
- keep calculations deterministic and bounded.

React may render more than once, interrupt work, discard a render, or run development checks that expose impurity. Code must remain correct regardless of render count.

Side effects belong in an event handler when caused by a specific user action, or in an Effect when needed to synchronize committed UI state with an external system.

## Props and Data Flow

Use props to declare configuration and data, and callbacks to express intent upward. Name callbacks for domain meaning (`onSave`, `onDismiss`) rather than internal event mechanics when abstraction warrants it.

- Keep prop surfaces small and cohesive.
- Pass stable identifiers or purpose-specific values rather than entire application objects when consumers need little of them.
- Do not mutate objects received from a parent.
- Avoid prop spreading onto DOM elements when it can leak invalid, private, or unsafe attributes.
- Distinguish omitted, `undefined`, `null`, empty, and false states when their semantics differ.
- Let native event behavior remain unless the component owns a reason to prevent it.

Prop drilling through a few transparent layers is often simpler than global context. Use composition or context only when the ownership and update reach justify it.

## State Ownership

For every state value, identify the component or external authority that owns it.

Keep state:

- minimal—exclude values calculable during render;
- normalized—avoid contradictory or duplicated representations;
- close to the components whose coordination requires it;
- modeled around UI states and transitions, not many loosely related booleans; and
- immutable, using functional updates when the next value depends on the previous one.

Lift state to the nearest common owner when siblings must stay synchronized. Do not lift leaf interaction state to the application root without a consumer or lifecycle need.

Choose controlled components when parents must coordinate or persist the value; choose uncontrolled/local state when encapsulation and simple use matter more. If supporting both, define initialization and mode-switch behavior and warn or prevent accidental switching.

Use a reducer when transitions are complex, several fields change together, or centralizing event-to-state logic improves correctness. A reducer must remain pure.

Use the state-management skill when deciding between URL, server cache, persistent storage, external stores, and shared client state.

## Derived Data

Calculate values from current props and state during render. Do not synchronize `fullName`, filtered lists, validation results, totals, or selection metadata through an Effect solely because their inputs changed.

Memoize a derived calculation only when profiling shows it is meaningfully expensive, referential stability is required by a measured optimized consumer, or the value is an intentional Effect dependency. `useMemo` is a performance hint, not semantic storage; code must remain correct if React recomputes it.

For expensive reusable domain computation, consider memoization outside individual components or changing the data/algorithm before adding component-level caches.

## Events

Event handlers express what happened. Put action-specific work there:

- update related state together;
- invoke callbacks;
- validate and submit;
- call mutations;
- show action outcomes; and
- navigate as a consequence of the event.

Use functional state updates when queued updates depend on prior state. Do not read state immediately after setting it and expect a new snapshot. If several events share policy, extract a regular function or reducer transition rather than triggering an Effect through an intermediary boolean.

Respect propagation and default browser behavior. Use semantic buttons, links, labels, and forms so keyboard and assistive-technology behavior does not depend on React event code.

## Effects

An Effect synchronizes a committed component with an external system: network connection, subscription, timer, browser API, imperative widget, observer, media controller, or non-React store.

Before writing an Effect ask:

1. What external system is being synchronized?
2. What starts the synchronization?
3. Which reactive values determine its configuration?
4. What stops or reverses it?
5. What happens when setup runs again or is interrupted?

If there is no external system, calculate during render or handle the action in an event.

Each Effect should represent one synchronization process. Dependencies describe every reactive value read; they are not a scheduling wish list. Do not disable exhaustive-dependency linting to force mount-only behavior.

Move stable constants outside the component, create effect-specific objects inside the Effect, use updater functions to avoid reading state only for an update, and use the installed version's Effect Event API when a callback must read latest values without resubscribing. Do not use refs to conceal dependencies.

Cleanup must undo setup for the exact resource instance. Abort or ignore stale asynchronous results, but remember aborting a client request may not cancel server-side work. Protect against responses arriving out of order.

## Choosing an Effect Variant

- Use `useEffect` for synchronization that can occur after paint.
- Use `useLayoutEffect` only for visual measurement or mutation that must occur before paint; it blocks rendering and does not run during server rendering.
- Reserve `useInsertionEffect` for style-library infrastructure.
- Use framework data mechanisms rather than ad hoc fetch Effects when they provide routing, server rendering, deduplication, caching, or race handling.
- Use `useSyncExternalStore` for subscriptions to external stores that need concurrent rendering and server snapshot correctness.

Do not choose layout effects to hide a flicker caused by incorrect state or structure. Fix the rendering model first.

## Refs and Imperative Work

Refs hold information not used to calculate rendered output, such as a DOM node, timer ID, previous external handle, or imperative integration. Updating a ref does not render.

- Access DOM refs after commit, not to drive ordinary rendering.
- Expose imperative handles sparingly and keep them minimal.
- Do not use refs as mutable state to avoid rerenders when UI depends on the value.
- Merge or forward refs according to the installed React API and project convention.
- Clean up callback refs and resources under remounting.

Prefer declarative props over commands such as `open()`, `setColor()`, or `reset()` unless integrating an inherently imperative system.

## Identity, Keys, and State Lifetime

React associates state with a component's type, key, and position in the rendered tree.

- Use stable domain identifiers for list keys.
- Keep keys unique among siblings, not globally.
- Do not generate keys during render.
- Expect changing a key or component type at a position to reset its subtree.
- Use an intentional key to reset a form or editor when identity truly changes.
- Keep the same key with the same logical entity through sorting, filtering, insertion, pagination, and optimistic updates.

Do not use keys to silence warnings without understanding identity. A wrong key can attach input state, focus, animation, or pending work to the wrong item.

## Context

Use context for values conceptually shared by a subtree, such as theme, locale, authenticated session view, or a feature-owned service. Avoid one global context containing fast-changing unrelated state.

- Place providers as low as the required reach allows.
- Split contexts by update frequency and responsibility.
- Keep provider values stable only when profiling or consumer behavior requires it.
- Define behavior when a provider is missing.
- Do not make reusable components silently depend on application-only context when props or composition would keep them portable.

Context solves transport, not state modeling. It does not provide persistence, cache invalidation, selectors, transactions, or authorization.

## Custom Hooks

A custom Hook reuses stateful logic or an external synchronization contract, not visual markup.

- Name it with `use` and follow all Hook rules.
- Give it a narrow responsibility and explicit inputs/outputs.
- Return intent-oriented operations rather than raw internal setters when invariants matter.
- Keep callback and object identity stable only when part of the documented contract.
- Propagate errors, pending state, cancellation, and cleanup deliberately.
- Test it through a representative component or hook harness.

Do not extract a Hook solely to move code out of sight. If it has no Hook call, a regular function may be clearer.

## Async Work, Actions, and Forms

Use the framework's supported data and mutation primitives. In versions supporting Actions and `useActionState`, model expected action outcomes, pending state, and progressive enhancement according to the renderer contract.

- Validate at the authoritative boundary.
- Prevent or tolerate duplicate submission.
- Keep user input after expected failures.
- Distinguish pending, success, validation, conflict, and unexpected error states.
- Do not optimistically claim success before durable completion.
- Reconcile optimistic state with authoritative results and rollback failures.

Native forms provide keyboard, submission, autofill, and no-script behavior. Preserve those capabilities unless the application deliberately replaces them.

## Suspense and Lazy Loading

Use `lazy` to defer component code that is expensive and not needed initially. Place `Suspense` around a meaningful region whose supported data or code can suspend.

- Keep navigation and task context visible while a region waits.
- Make fallback dimensions stable and accessible.
- Avoid a boundary so high that one slow leaf replaces the whole page.
- Avoid many tiny fallbacks that produce visual noise.
- Use transitions to retain already revealed content during non-urgent updates when appropriate.
- Let the active framework define data-fetching integration; arbitrary Effect fetches do not activate Suspense.

Suspense does not catch errors; pair it with an appropriate error boundary when failure is possible.

## Error Boundaries

Error boundaries contain unexpected render failures in their descendant tree. Scope them around units users can recover independently while preserving application navigation and work.

Expected validation and domain errors should be modeled and rendered normally. Event-handler and arbitrary asynchronous errors do not automatically reach a render error boundary; handle them at their execution boundary or convert them to rendered state deliberately.

Log technical detail with privacy-safe context, show actionable user-facing recovery, and reset the boundary when the failed resource identity changes. Do not expose stack traces or opaque diagnostics as user copy.

## Concurrency and Responsiveness

Urgent updates such as typing and direct manipulation should remain immediate. Use a Transition for non-urgent rendering work whose pending state and interruption semantics are acceptable. Use a deferred value when a slower subtree may lag behind a rapidly changing input.

- Do not use a Transition to control text input state.
- Show pending feedback without hiding already useful content.
- Expect transition work to be interrupted and restarted; render and state transitions must remain pure.
- Preserve ordering and correctness for asynchronous actions according to the installed API; not every custom async wrapper handles ordering automatically.

Concurrency changes scheduling, not computational cost. Reduce or partition expensive work if total main-thread time remains excessive.

## Performance and Memoization

Profile production builds with React DevTools and browser tools. Determine whether cost comes from component execution, DOM changes, layout/paint, effects, data transformation, or third-party work.

Before memoizing:

1. remove unnecessary Effects and cascading updates;
2. keep state local and children compositional;
3. fix unstable keys and overly broad context;
4. reduce expensive work and data volume; and
5. measure the remaining component path.

Use `memo` when a component rerenders often with equal props and its render is demonstrably expensive. Use `useMemo` for an expensive calculation or required stable value, and `useCallback` when function identity matters to an optimized child or dependency.

Inspect whether React Compiler is enabled. Stable React Compiler can apply automatic memoization; for new compiled code, prefer pure idiomatic React and rely on compiler analysis unless precise control is needed. Preserve existing manual memoization unless measured testing supports removal, because compilation output and dependency identity can change.

Memoization has comparison, memory, dependency, and maintenance cost. It does not fix impure rendering or incorrect Effects.

## Accessibility

Render semantic HTML, preserve keyboard behavior, label controls, expose state, and manage focus for dialogs, errors, navigation, and dynamic content. React abstractions do not change platform accessibility requirements.

- Use stable `useId`-style identifiers for accessibility relationships where the installed version supports them; do not use them as list keys.
- Forward supported DOM attributes through reusable primitives deliberately.
- Keep hidden and unmounted behavior distinct.
- Preserve focus through conditional rendering and list changes.
- Announce asynchronous outcomes without duplicate live-region updates.

Apply the accessibility skill for a complete review.

## Testing

Test observable behavior through roles, names, labels, text, and user interactions.

- Prefer user-level queries over class names and component internals.
- Exercise keyboard and pointer paths.
- Cover initial, pending, success, empty, validation, failure, disabled, and cleanup states.
- Use realistic providers and only the minimal mocked boundaries.
- Verify subscriptions and timers clean up under rerender and unmount.
- Test list reorder and state preservation when identity matters.
- Test Strict Mode in development where the application uses it.
- Use end-to-end tests for framework navigation, hydration, and server/client integration.

Avoid snapshots as the only assertion for interactive behavior. Do not make production code more complex solely to reach implementation details from tests.

## Review Checklist and Output

Before finishing:

1. Confirm render purity, immutable updates, and Hook rules.
2. Remove redundant state and unnecessary Effects.
3. Verify state ownership, controlled behavior, keys, and reset semantics.
4. Check cleanup, races, stale closures, errors, and pending states.
5. Test semantic output, keyboard access, focus, and assistive-technology relationships.
6. Profile before retaining performance-specific complexity.
7. Run lint, type checks, focused tests, and the applicable production build.

Report substantial work as:

```text
React change:
- React version, renderer, framework, and compiler status:
- Component and state ownership:
- Events, Effects, and external systems:
- Identity and async behavior:
- Accessibility behavior:
- Performance evidence:
- Validation performed:
- Trade-offs or remaining risks:
```

Do not call code idiomatic, concurrent-safe, accessible, or optimized merely because it uses modern hooks. Demonstrate the behavior and preserve the project's actual runtime contract.
