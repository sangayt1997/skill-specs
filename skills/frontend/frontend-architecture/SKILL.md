---
name: frontend-architecture
description: Design or revise browser-application structure, feature boundaries, rendering strategy, dependency flow, shared UI foundations, and delivery topology. Apply when frontend-wide organization or cross-feature decisions affect maintainability and team autonomy; use framework or component guidance for local implementation details.
---

# Frontend Architecture

Structure a frontend so product capabilities can evolve without uncontrolled dependency, duplicated policy, inconsistent experiences, or excessive delivery risk. Treat architecture as responsibility, ownership, runtime, and release decisions—not a preferred folder tree.

Choose the simplest architecture that meets current product, team, performance, security, and operational needs. A coherent single application with enforced modules is usually the baseline; independently deployed frontends require independent business and delivery boundaries strong enough to justify their user and operational costs.

## Working Method

1. Inspect the current application, framework, build system, routes, packages, dependencies, deployment, and ownership.
2. Identify user journeys, domain capabilities, shared platform concerns, data authorities, rendering needs, and likely change patterns.
3. Map source, runtime, styling, state, API, build, and team coupling.
4. Define proposed boundaries, public contracts, dependency direction, composition points, and ownership.
5. Choose rendering and delivery strategies per route or experience from measurable needs.
6. Evaluate accessibility, performance, security, resilience, testing, migration, and operational consequences.
7. Enforce stable rules through language, package, lint, build, and ownership mechanisms.
8. Migrate in reversible slices, validate representative journeys, and remove temporary paths.

Preserve project conventions unless they are the demonstrated problem. Do not reorganize an entire repository to implement one local feature.

## Non-Negotiable Guardrails

- **MUST** keep the user experience coherent across ownership and deployment boundaries.
- **MUST** define authority for routes, data, domain rules, shared UI, authentication, configuration, and cross-cutting behavior.
- **MUST** make allowed dependencies and public entry points enforceable.
- **MUST** preserve accessibility, security, performance budgets, compatibility, and rollback behavior during migration.
- **MUST NOT** introduce a micro-frontend, monorepo, design system, global store, event bus, or backend-for-frontend solely because it is an industry pattern.
- **MUST NOT** let feature modules import private files from other features.
- **MUST NOT** expose secrets or trusted authorization logic in client-delivered code.
- **SHOULD** optimize boundaries for localized change and independent understanding before independent deployment.
- **SHOULD** keep framework and vendor mechanisms at replaceable edges where doing so has present value.
- **MAY** accept a documented temporary boundary violation with one owner and removal condition during migration.

## Architecture Drivers

State which forces justify architectural work:

- user journeys, navigation, offline behavior, and device constraints;
- accessibility and internationalization requirements;
- first-load, interaction, and navigation performance targets;
- search indexing, link previews, and content freshness;
- security, privacy, tenancy, and regulatory boundaries;
- traffic and data shape;
- number, topology, and autonomy of teams;
- release frequency, blast radius, and rollback needs;
- supported browsers, runtimes, and hosting platform; and
- delivery deadline, budget, and legacy compatibility.

Turn vague qualities into scenarios. “Modular” can mean a feature changes without editing another feature; “independent” can mean a team can test and release without coordinated deployment; “fast” needs route-specific metrics and budgets.

## System and Runtime Boundaries

Draw a context view containing users, the browser application, origin or edge, APIs, identity provider, content systems, analytics, third-party scripts, and external integrations. Mark trust, network, deployment, and ownership boundaries.

Within the frontend, distinguish:

- application shell and global composition;
- route or product-area modules;
- domain or feature modules;
- shared UI foundations and design tokens;
- infrastructure adapters such as HTTP, storage, telemetry, and flags;
- build-time and server-only modules; and
- browser-only code and workers.

Do not confuse a source folder with a runtime boundary. Code may share a repository yet deploy independently, or live in packages while shipping in one bundle. Document both source and runtime structures when they differ.

## Organize Around Capabilities

Group code that delivers one product capability and changes together. A feature module may contain its routes, components, state, validation, queries, tests, and adapters while exposing a small entry point.

Prefer this conceptual dependency direction:

```text
application composition -> features -> domain/shared foundations -> platform adapters
```

Adapt names to the project. The important property is that high-level product modules do not become reachable through arbitrary deep imports and shared foundations do not depend back on features.

Avoid organizing only by technical type—one global folder each for components, hooks, services, and models—when a feature change then spans the whole tree. Technical groupings remain useful for genuinely shared platform code.

## Public Contracts and Dependency Rules

Give each module one documented public entry point or export map where tooling supports it. Expose capability-level operations and stable types; hide internal component trees, query keys, transport records, and implementation helpers.

- Prevent deep imports through package exports, path rules, linting, or build boundaries.
- Keep dependencies acyclic.
- Distinguish runtime dependencies from type-only and development dependencies.
- Avoid broad barrel files that pull unrelated modules into bundles or create cycles.
- Keep side effects at explicit initialization points.
- Ensure shared packages declare their runtime assumptions: browser, server, worker, or universal.

When two modules must coordinate frequently, consider moving orchestration to a common owner or merging the boundary. Do not hide conceptual coupling behind a generic event bus.

## Rendering Strategy

Choose rendering per route or content class rather than declaring one universal mode.

Consider:

- static generation for content known ahead of time and cacheable across users;
- dynamic server rendering for personalized or frequently changing initial HTML;
- streaming when progressive delivery improves meaningful rendering;
- client rendering for highly interactive authenticated experiences where initial HTML and indexing are less important; and
- partial or selective client activation to avoid shipping interactivity where it is not needed.

Evaluate time to first byte, meaningful content, hydration or boot cost, interaction responsiveness, caching, personalization, SEO, resilience without JavaScript, hosting complexity, and data locality.

Server-rendered HTML can appear interactive before event handlers are ready. Preserve semantic browser behavior and test the interval before hydration. Avoid rendering the same expensive data and UI work twice without evidence the trade-off is worthwhile.

## Server and Client Responsibilities

Keep trusted work—secrets, privileged credentials, authorization enforcement, protected data filtering, and sensitive business rules—on a trusted server. Client checks improve UX but do not enforce access.

Prefer server or build execution for work that does not need browser state or immediate interaction when it reduces shipped JavaScript and round trips. Use client execution for browser APIs, local interaction, optimistic feedback, and truly dynamic state.

Define serialization boundaries. Only send data the client is authorized to receive, in stable and minimal forms. Avoid duplicating domain policy across server and browser; if duplication is necessary for responsiveness, keep the server authoritative and test parity.

## Routing and Navigation

Routes are durable user and integration contracts.

- Use stable, meaningful URLs for navigable state.
- Define route ownership, parameters, validation, canonicalization, and authorization.
- Preserve browser history, deep linking, refresh, opening in a new tab, and shareability.
- Provide route-level loading, empty, error, unauthorized, and not-found behavior.
- Decide prefetching from likely benefit and data sensitivity; do not fetch every possible destination.
- Coordinate document title, metadata, focus, scroll restoration, analytics, and page-view semantics.

Keep navigation policy in an explicit router or composition layer rather than scattered click handlers.

## Data Access Architecture

Map every frontend datum to its authority and lifecycle: server resource, URL state, local interaction, shared client workflow, persisted preference, or derived value.

- Put transport logic behind feature-appropriate clients or adapters.
- Validate external data at a trustworthy boundary when malformed data is plausible or dangerous.
- Separate transport schemas from UI view models when their change drivers differ.
- Centralize authentication, base URL, tracing, cancellation, error normalization, and retry policy without creating a generic repository that erases domain meaning.
- Co-locate query definitions and cache keys with their owning feature.
- Define freshness, invalidation, optimistic updates, and reconciliation.

Do not copy server data into a general client store by default. Use the state-management skill for ownership and synchronization choices.

## Shared UI and Design-System Boundaries

Separate foundations from product composition:

- tokens encode named design decisions;
- primitives encode semantic, accessible low-level behavior;
- components encode reusable interaction and visual contracts; and
- feature compositions encode domain-specific workflows.

Shared UI must have clear ownership, versioning, supported variants, accessibility behavior, theming, and migration policy. Keep business rules out of generic components. Prefer composition over flag-heavy components with many unrelated modes.

Avoid creating a design system for a few local styles. Conversely, when repeated primitives have accessibility or consistency risk, centralizing them reduces broad regression exposure.

## Styling Architecture

Choose a styling mechanism compatible with rendering, theming, caching, and team constraints. Regardless of tool:

- define global styles and reset ownership;
- scope component styles to prevent accidental leakage;
- establish token and theme precedence;
- keep specificity predictable;
- support responsive, forced-color, reduced-motion, and localization needs;
- avoid runtime style generation when its cost violates performance goals; and
- prevent independently delivered surfaces from silently overriding one another.

Do not encode meaningful content in CSS alone. Keep source order accessible when changing layout.

## State and Event Flow

Prefer local ownership and explicit downward data/upward intent for component trees. Promote state only when multiple owners require one coherent value. Treat server cache, URL, form draft, and durable client preferences as different categories.

For cross-feature communication, prefer an explicit application-level contract: route transition, shared domain service, or narrowly defined event. Events should describe completed facts or intentional commands, include ownership and schema, and avoid becoming an invisible global control flow.

Keep derived values computed rather than synchronized. Use the state-management skill for deeper decisions.

## Error and Resilience Boundaries

Design failures at the level users can recover:

- distinguish validation, authentication, authorization, not-found, conflict, offline, timeout, dependency, and unexpected errors;
- preserve unaffected shell and routes when a feature fails;
- provide retry only for safe operations and retain user input;
- scope error boundaries so one widget does not blank the entire application, without hiding systemic failure;
- handle stale assets and mixed client/server versions after deployment; and
- make offline or degraded behavior explicit rather than accidental.

Log diagnostic detail without exposing it to users or leaking private data. Central error handling should normalize infrastructure concerns but allow feature-specific recovery and copy.

## Micro-Frontend Decision

Consider independently delivered frontend units only when several of these are real requirements:

- autonomous teams own distinct business capabilities end to end;
- independent release and rollback materially reduce coordination or risk;
- incremental replacement cannot be achieved with modules in one deployment;
- runtime isolation or different technology lifecycles are necessary; and
- a stable shell and integration contract can preserve one product experience.

Account for duplicate dependencies, larger payloads, version skew, routing, authentication, shared state, styling isolation, accessibility consistency, observability, local development, end-to-end testing, incident ownership, and atomic cross-boundary changes.

Prefer build-time packages or a modular monolith when independent runtime deployment is not needed. If using micro-frontends, minimize communication, align boundaries with user-visible capabilities, publish compatibility contracts, and keep shared runtime dependencies deliberately governed.

## Repository and Package Strategy

Choose a monorepo or multiple repositories from ownership and delivery needs, not frontend fashion.

A monorepo can support atomic changes, shared tooling, dependency visibility, and coordinated refactoring, but needs boundary enforcement and scalable CI. Multiple repositories can strengthen autonomy and permissions, but increase versioning, discovery, duplicated automation, and cross-repository change cost.

For internal packages:

- publish only when independent consumption or release is required;
- define ownership and support policy;
- use semantic compatibility appropriate to consumers;
- test package exports and built artifacts, not only source aliases;
- avoid multiple incompatible copies of singleton runtimes; and
- automate dependency and API-boundary checks.

## Build and Delivery Architecture

Make the build reproducible and environment differences explicit.

- Separate public build-time values from server secrets.
- Validate environment configuration and fail safely.
- Keep production source maps protected when they contain sensitive context.
- Use route or feature code splitting driven by actual navigation and bundle evidence.
- Set budgets for initial and incremental JavaScript, CSS, images, and third parties.
- Cache content-addressed immutable assets and version mutable entry documents correctly.
- Support progressive rollout, health signals, rollback or roll-forward, and stale-client compatibility.

Do not make correctness depend on deleting every user's cached asset. Design API and persisted-state compatibility across realistic client lifetimes.

## Security and Trust

- Treat all browser code and storage as observable and modifiable by the user.
- Enforce authorization and sensitive validation on trusted systems.
- Minimize client data and third-party script access.
- Use platform defenses such as CSP, trusted output encoding, secure cookies, and integrity controls according to the threat model.
- Isolate untrusted content and sanitize only with maintained, context-aware mechanisms.
- Define token storage and renewal from the application's actual attack model.

Architecture must expose trust boundaries and third-party ownership. A shared analytics helper must not become an unrestricted path for personal data.

## Testing Architecture

Align tests with boundaries:

- unit tests for deterministic domain and presentation policy;
- component tests for reusable UI behavior and accessibility;
- contract tests for API, package, and independently deployed integrations;
- integration tests for routing, data, state, and browser behavior; and
- a focused set of end-to-end tests for critical journeys and deployment composition.

Avoid requiring every feature test to boot the complete product. Provide test seams at real contracts rather than adding artificial abstraction solely for mocks. Independently deployed units still need tests proving the composed experience.

## Observability and Ownership

Instrument user journeys, route transitions, errors, Web Vitals, API dependencies, releases, and feature flags with privacy-aware correlation. Attribute signals to route, version, deployment unit, and responsible owner.

Define who owns the shell, shared UI, build platform, integrations, and cross-feature incidents. A boundary without operational ownership is incomplete.

## Incremental Evolution

1. Characterize current routes, contracts, and critical journeys.
2. Introduce the target boundary and public entry point.
3. Route one vertical slice through it without duplicating authority.
4. Add enforcement after the boundary is proven.
5. Measure bundle, runtime, accessibility, reliability, and delivery effects.
6. Migrate consumers in bounded increments.
7. Remove adapters, flags, duplicate state, and obsolete code after verified exit criteria.

Avoid wholesale rewrites unless incremental change is demonstrably less safe or more expensive. Transitional architecture must remain testable, observable, and supportable.

## Validation and Decision Output

Before finishing:

1. Trace representative features and verify changes remain localized.
2. Inspect dependency and bundle graphs for cycles, deep imports, duplicate runtimes, and unexpected shared fan-in.
3. Test route entry, navigation, refresh, errors, accessibility, responsive layouts, and stale-version compatibility.
4. Compare rendering behavior using production-like network and device constraints.
5. Verify security boundaries, public configuration, third-party access, and data minimization.
6. Exercise build, deployment, rollback or repair, and ownership routing.
7. Confirm temporary exceptions have owners and removal conditions.

Record consequential work as:

```text
Frontend architecture decision:
- Drivers and constraints:
- Current structure and problem evidence:
- Proposed boundaries and owners:
- Dependency and composition rules:
- Rendering and delivery strategy:
- Data, state, and contract ownership:
- Accessibility, performance, security, and operations:
- Alternatives and trade-offs:
- Migration, validation, and exit criteria:
```

Do not claim architectural improvement from a new directory layout alone. Show reduced change coupling, clearer ownership, safer delivery, or better user outcomes.
