---
name: state-management
description: Choose, model, implement, or review frontend state ownership across component state, URL, server cache, shared client workflows, forms, and browser persistence. Apply when state is duplicated, synchronized, shared, persisted, or handled by a store; preserve the repository's existing solution unless evidence justifies change.
---

# State Management

Give each piece of state one clear authority, a lifecycle matching the user experience, and an update path that preserves invariants. Use the smallest state mechanism that meets sharing, persistence, synchronization, performance, and debugging needs.

State management is primarily an ownership and lifecycle problem. A global store does not resolve ambiguous authority, redundant values, server freshness, or URL semantics; it can merely centralize them.

## Working Method

1. Inventory the state involved and classify each value by authority, consumers, lifetime, and write path.
2. Remove values derivable from existing state or props.
3. Put state in the narrowest owner capable of coordinating all legitimate consumers.
4. Choose the mechanism by state category rather than using one store for everything.
5. Define initialization, transitions, validation, concurrency, errors, reset, persistence, and migration.
6. Expose narrow selectors and intent-oriented operations.
7. Test transitions, rerenders, navigation, reload, multiple tabs, stale data, failures, and cleanup as applicable.
8. Measure before introducing selector memoization, fine-grained subscriptions, normalization, or a new library.

Do not replace an established store or data-fetching solution to implement one feature unless the user requests it or the current tool cannot meet a demonstrated requirement.

## Non-Negotiable Guardrails

- **MUST** identify one authoritative owner for every independent fact.
- **MUST** keep state transitions valid, immutable where required by the tool, and observable through supported APIs.
- **MUST** distinguish server data, client interaction state, URL state, form drafts, and persisted preferences.
- **MUST** define freshness, invalidation, identity, and error behavior for cached server data.
- **MUST** validate and version untrusted or persisted state before use.
- **MUST NOT** store secrets, trusted authorization decisions, or sensitive tokens in ordinary frontend state or web storage.
- **MUST NOT** mirror the same writable fact in multiple stores without an explicit authority and synchronization protocol.
- **MUST NOT** put derived values in state merely to avoid recalculation.
- **MUST NOT** make every local UI flag global for consistency.
- **SHOULD** express domain changes as intent rather than exposing arbitrary setters.

## Classify State Before Choosing a Tool

Use these categories:

| Category | Typical authority and mechanism | Key concern |
| --- | --- | --- |
| Local UI | Owning component or local reducer | Component lifetime and reset |
| Shared client workflow | Nearest common owner, context/reducer, or existing store | Coordinated transitions |
| Server resource | Server plus framework/query cache | Freshness, invalidation, races |
| URL/navigation | Router and URL | Shareability, history, parsing |
| Form draft | Form/component owner or form library | Validation, dirty state, submission |
| Persistent preference | Server profile or versioned browser storage | Privacy, migration, cross-device behavior |
| External browser state | Purpose-built subscription | Consistent snapshots and cleanup |
| Derived state | Computation or selector | Avoid synchronization |

One feature can use several categories. A search page may keep the query and filters in the URL, results in a server-data cache, open-row state locally, and column preferences in versioned storage.

## Model State and Transitions

Describe state in terms of meaningful modes and events. Avoid independent booleans that permit impossible combinations such as `isLoading && isSuccess && hasError`.

Use a discriminated model when states have different valid data:

```text
idle
pending(previousData?)
success(data)
empty
failure(error, previousData?)
```

Define:

- initial state and source;
- valid events and transitions;
- invariants protected by each transition;
- pending and cancellation behavior;
- expected versus unexpected errors;
- reset and identity change;
- optimistic state and rollback; and
- persistence or synchronization side effects.

Reducers are useful when several fields change together or transitions need one testable policy. Keep reducers pure and perform effects in the surrounding execution mechanism.

## Keep State Minimal

Do not store a value if it can be calculated from current authoritative inputs during render or through a selector. Common redundant state includes filtered lists, totals, full names, validity, selected objects duplicating selected IDs, and flags derivable from request status.

Benefits of derivation:

- no synchronization Effect;
- no stale intermediate render;
- fewer transitions and impossible states;
- easier serialization and debugging; and
- one place to change the rule.

Memoize only expensive or referentially significant selectors after measuring. Memoization is not authority and its cache may be discarded.

## Local State

Keep transient interaction state local when no distant consumer needs it: disclosure, hover, current tab within a component, draft input, pending affordance, measured layout, or widget-specific selection.

- Initialize from props only when the prop is an initial value and future changes intentionally do not control state.
- If the parent must control the value, accept it as controlled state and emit intent changes.
- Reset using component identity, an explicit event, or navigation lifecycle—not an Effect copying new props.
- Lift only as high as the nearest owner coordinating the consumers.

Locality limits rerenders, reduces coupling, and makes deletion easier. It is not less architectural than a store.

## Shared Client State

Use shared client state for information created and owned by the current application session that several distant components must coordinate: a multi-step workflow, unsaved workspace, local selection spanning panes, or client-only domain simulation.

Start with lifted state and props. Use context with a reducer for a complex subtree when update frequency and consumer reach are manageable. Use the project's external store when state crosses many independent trees, needs selector subscriptions, middleware, devtools, undo, offline operations, or non-React consumers.

For store design:

- organize by domain ownership rather than screen or action type;
- expose commands/events and selectors, not a raw mutable singleton;
- keep update logic near owned state;
- normalize relational collections when updates and lookup benefit;
- subscribe to the smallest stable slice needed;
- keep initialization deterministic; and
- define store lifetime per application, request, route, workspace, or test.

Do not create one process-global server-rendering store shared across requests. Isolate request and user state.

## Server State and Query Caches

Server data remains authoritative on the server. A client query cache is a time-bounded replica with asynchronous lifecycle, not ordinary application state.

For every query define:

- stable key containing all inputs that change the result, including tenant or scope where relevant;
- fetch function, authentication context, and cancellation behavior;
- fresh/stale policy and garbage-collection lifetime;
- retry conditions and limits;
- initial, placeholder, and previous-data semantics;
- invalidation or direct update after mutations;
- pagination/infinite-query identity; and
- error, offline, focus, and reconnect behavior.

Inspect the installed library version and defaults. Query libraries may consider data stale immediately, refetch on mount/focus/reconnect, retry failures, structurally share results, and collect inactive entries after a default interval. Configure from product semantics, not surprise avoidance.

Do not copy query results into a global client store merely so distant components can read them; subscribe to the cache through its supported API. Keep client-only edits separate until committed or model an explicit optimistic overlay.

## Query Keys and Invalidation

Query keys are cache identity contracts.

- Include every parameter affecting authorization, locale, filters, sort, pagination, representation, or result.
- Use a consistent hierarchical factory or convention.
- Avoid object identity or unstable serialization when the library does not normalize it.
- Never omit tenant/user scope from shared caches.
- Invalidate the narrowest domain set that became stale.
- Await invalidation when the workflow must remain pending until fresh data is visible.

Prefer invalidation and authoritative refetch when recomputing all affected cached views is complex. Use direct cache updates when the mutation response contains authoritative data and all impacted keys are known.

Test two users or tenants, parameter changes, inactive queries, navigation away/back, and concurrent mutations to detect cache contamination and stale views.

## Mutations and Optimistic State

Use optimistic UI only when success is likely, the action is reversible or reconcilable, and temporary divergence will not mislead users about a critical outcome.

Define:

- client correlation or idempotency identity;
- which in-flight queries must be canceled or protected;
- optimistic overlay or cache update;
- snapshot/rollback or authoritative refetch;
- concurrent optimistic mutation ordering;
- server conflict and validation response;
- final invalidation/reconciliation; and
- user messaging while pending and after failure.

For financial, destructive, permission, inventory, or externally visible actions, prefer truthful pending UI over false success unless the domain explicitly supports optimistic semantics.

Do not let a late response overwrite newer state. Associate results with request identity, version, or latest accepted transition.

## URL State

Put state in the URL when it should survive refresh, participate in back/forward navigation, be shareable/bookmarkable, or identify a server-renderable resource or view.

Common URL state includes search terms, filters, sorting, pagination, selected resource, tab representing a meaningful subview, and modal routes that users can deep-link.

- Parse and validate all URL input; it is untrusted.
- Define defaults and canonical serialization.
- Keep ordering deterministic and omit redundant default parameters when useful.
- Use push for meaningful navigable changes and replace for transient corrections or high-frequency edits.
- Debounce only URL writes where history and responsiveness semantics remain correct.
- Preserve unrelated parameters owned by other features.
- Handle browser back/forward as an authoritative state change.

Do not duplicate URL state in a writable store. Derive from the router and write through navigation. Temporary input may remain local until the user commits it to the URL.

## Form State

Keep ordinary form drafts local to the form or established form library. Form state includes raw values, touched/dirty metadata, client errors, submission status, and possibly a baseline for reset.

- Preserve raw user input even when it is temporarily invalid.
- Normalize at a deliberate boundary rather than on every keystroke when normalization disrupts editing.
- Validate authoritatively on submit and expose field plus form-level outcomes.
- Keep server validation errors associated until the relevant value changes or the next submission.
- Prevent or tolerate duplicate submission.
- Reset only after confirmed success or explicit user intent.
- Warn before discarding meaningful unsaved work according to product policy.

Do not dispatch every keystroke to a global store without a cross-form consumer, live preview, persistence, or collaboration need. If drafts persist, version and migrate them and distinguish them from committed server records.

## Context

Context transports a value through a tree; it is not automatically a complete state-management solution.

Use it for stable or subtree-owned state such as theme, locale, dependency/service instances, authenticated session view, or a reducer-owned workflow. Split contexts by responsibility and update frequency. Place providers close to consumers.

Every consumer rerender behavior depends on provider value identity and framework/compiler behavior. Avoid one context object combining rapidly changing state with stable operations. Memoize provider values only when measured or contractually needed.

Define a clear error or default when a required provider is absent. Context values in the client are not trusted authorization.

## External Stores

An external store is justified when state must exist outside the component tree, many independent consumers need fine-grained subscriptions, or non-React systems update it.

Require:

- a synchronous immutable snapshot contract compatible with the renderer;
- subscription and unsubscription;
- server snapshot behavior for SSR/hydration;
- stable selectors/equality semantics;
- isolated instances for tests and requests;
- batching or transaction behavior; and
- devtools or logging that redacts sensitive values.

Use the renderer's supported external-store subscription API rather than an ad hoc Effect subscription, which can tear or hydrate inconsistently under concurrent rendering.

## Persistence and Browser Storage

Choose persistence by value and scale:

- URL for shareable navigable state;
- server profile for cross-device durable preferences and authoritative records;
- cookie for small request-visible values with appropriate security properties;
- session storage for tab-scoped disposable values;
- local storage for small origin-scoped preferences that tolerate synchronous access and eviction; and
- IndexedDB for larger structured, indexed, transactional, asynchronous local data.

Browser storage is user-controlled, origin-scoped, quota-limited, evictable, unavailable in some modes, and readable by scripts with origin access. Do not store secrets or assume durability.

For persisted state:

- define a schema version and migration or discard path;
- validate on read and handle corrupt, missing, old, or future data;
- namespace keys by application and identity where necessary;
- bound size and retention;
- clear identity-specific data on logout/account switch;
- coordinate multiple tabs through supported events or channels when required;
- handle quota and denied-access failures; and
- avoid synchronous large serialization on the main thread.

Do not persist an entire global or query cache by default. Select fields, redact sensitive data, set maximum age, and use a build/schema buster when incompatible releases must discard it.

## Server Rendering and Hydration

Never share per-request state through a module-global store on the server. Create isolated store/cache instances per request and send only authorized serializable state to the client.

- Ensure server and client initial snapshots match.
- Do not read browser storage during server render.
- Reconcile persisted client preferences after hydration without creating misleading flashes where possible.
- Keep hydration payload minimal and escape it safely.
- Preserve timestamps/freshness metadata for dehydrated server queries.
- Understand whether framework server components and client caches can diverge after client refetch.

If the same data renders in both a server component and a client query cache, define which layer revalidates the server output; otherwise counts or summaries may become inconsistent.

## Normalization and Selectors

Normalize relational client-owned data when entities repeat across views and independent updates need one identity. Typical shape: entity tables keyed by ID plus ordered ID lists. Do not normalize small, nested, read-only server responses without an update or lookup benefit.

Selectors:

- encapsulate reads and derived policy;
- accept explicit parameters;
- return stable references only when consumers benefit;
- avoid allocating new arrays/objects on every subscription if equality depends on identity; and
- remain pure.

Memoized selectors need cache scope appropriate to parameters and store instances. A single-entry cache can thrash across many component instances; an unbounded cache can leak memory.

## Concurrency and Synchronization

Assume asynchronous results can complete out of order and updates can originate from server responses, other tabs, workers, reconnects, or collaborative peers.

- Give operations identity or version.
- Cancel obsolete reads where supported and ignore stale completion.
- Define last-write-wins, compare-and-swap, merge, conflict, or CRDT semantics from the domain.
- Make retries idempotent or duplicate-safe.
- Reconcile offline queues in order with visible failure handling.
- Do not use browser timestamps alone as a trustworthy global ordering source.

Effects that mirror one state container into another are a warning sign. Prefer one authority or an adapter with explicit direction, conflict behavior, and lifecycle.

## Security and Privacy

- Treat all client state as observable and modifiable by the user.
- Enforce permissions and invariants on trusted systems.
- Minimize personal and sensitive data in memory, URLs, logs, devtools, persistence, and hydration.
- Never place secrets in query strings or ordinary storage.
- Clear user-scoped caches and stores on logout or identity change.
- Isolate tenants in keys, storage namespaces, and server-rendering instances.
- Redact state in analytics, crash reports, action logs, and time-travel tools.

Persisted feature flags or roles can guide presentation but cannot authorize behavior.

## Performance

Diagnose whether the cost is update frequency, subscription breadth, selector work, object churn, provider reach, data volume, serialization, or DOM rendering.

- Subscribe to the smallest meaningful slice.
- Keep state local to avoid unrelated subscribers.
- Batch coherent updates through supported mechanisms.
- Preserve structural sharing for unchanged branches.
- Avoid selectors that scan huge collections for every consumer.
- Bound caches and histories.
- Use normalized entities or indexes when measured access patterns justify them.

Do not add a global store to improve performance without a trace. External stores can reduce some renders while adding subscription and consistency complexity.

## Testing

Test invariants and observable transitions rather than library internals.

- Pure-test reducers, state machines, selectors, parsers, serializers, and migrations.
- Component-test controlled/uncontrolled behavior and local resets.
- Integration-test providers, query caches, invalidation, optimistic rollback, URL navigation, and persistence.
- Test reload, back/forward, multiple tabs, offline/reconnect, account switch, stale responses, duplicate mutations, and corrupted storage as relevant.
- Verify SSR request isolation and hydration consistency.
- Measure rerenders or selector work only for demonstrated performance risks.

Create fresh store and cache instances per test unless shared lifetime is the behavior under test. Resetting a singleton after each test can hide cross-request leakage.

## Migration

When changing ownership or libraries:

1. Characterize current behavior and state lifetime.
2. Define the destination authority and contract.
3. Move one vertical slice with an adapter at the old boundary.
4. Keep writes flowing to one authority; avoid indefinite bidirectional sync.
5. Migrate persistence with versioned read/transform/write or safe discard.
6. Measure bundle, rerender, network, and user-flow effects.
7. Remove old providers, subscriptions, hydration data, storage keys, and adapters after exit criteria.

Do not combine a state-library migration with unrelated visual redesign or API rewrite unless coordinated explicitly.

## Decision Output

Before finishing, verify authority, derived values, transitions, async races, security, persistence, rerender scope, and reset behavior. Run the repository's lint, type, focused tests, and production build where applicable.

Report substantial decisions as:

```text
State-management decision:
- State inventory and categories:
- Authority and consumers:
- Lifetime, initialization, and reset:
- Transitions and invariants:
- Server freshness and invalidation:
- URL or persistence semantics:
- Concurrency and error handling:
- Security and privacy:
- Performance evidence:
- Validation and migration:
```

Do not claim a single source of truth if multiple writable copies remain. Name the authority, explain every replica, and show how divergence is prevented or reconciled.
