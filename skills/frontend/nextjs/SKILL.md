---
name: nextjs
description: Implement, refactor, debug, or review Next.js applications using version-appropriate routing, server/client boundaries, rendering, data access, caching, mutations, metadata, and deployment behavior. Apply to Next.js-specific work; inspect the installed version and router before using framework APIs because conventions change across releases.
---

# Next.js

Build Next.js features that match the repository's installed version, router, runtime, and hosting model. Use framework primitives where they clarify ownership and delivery, while preserving standard React and web-platform behavior.

Next.js changes materially between versions. Treat the local package manifest, lockfile, configuration, and version-matched official documentation as authoritative. Do not copy caching, request API, middleware/proxy, or experimental-feature guidance from another major version.

## Working Method

1. Inspect `package.json`, lockfile, `next.config.*`, TypeScript configuration, scripts, deployment adapter, and environment policy.
2. Determine the exact Next.js and React versions, App Router and/or Pages Router, enabled flags, and target runtime.
3. Read nearby routes, layouts, data modules, actions, handlers, tests, and conventions before editing.
4. Classify the requirement by route, execution environment, data authority, freshness, interactivity, and security.
5. Keep server execution as the default in App Router; introduce the smallest client boundary required by interaction or browser APIs.
6. Define loading, errors, not-found, authorization, caching, invalidation, metadata, and accessibility along with the success path.
7. Validate development and production behavior, including direct navigation, client navigation, refresh, build, and deployment runtime.
8. Report version-sensitive assumptions and any behavior not verified in the target host.

Do not upgrade Next.js, switch routers, enable an experimental or opt-in feature, or change deployment platform unless requested or required and authorized.

## Non-Negotiable Guardrails

- **MUST** verify installed versions before selecting an API or assuming a default.
- **MUST** enforce authentication, authorization, validation, and sensitive data filtering in trusted server code at every public entry point.
- **MUST** make cache scope, freshness, invalidation, and user/tenant isolation explicit.
- **MUST** keep secrets and server-only modules out of client dependency graphs.
- **MUST** handle expected errors, uncaught exceptions, loading, and missing resources deliberately.
- **MUST NOT** mark a broad layout or feature tree with `'use client'` merely to make one leaf interactive.
- **MUST NOT** call an internal Route Handler from a Server Component when the authoritative server function can be invoked directly.
- **MUST NOT** assume old implicit `fetch` caching rules apply to newer Next.js configurations.
- **MUST NOT** use Proxy, Middleware, layouts, or hidden UI as the only authorization control.
- **SHOULD** keep route files thin and move domain/data policy into owned server modules.

## Establish Version and Router Context

Before coding, record:

- Next.js and React versions;
- package manager and lockfile;
- App Router, Pages Router, or mixed migration;
- Node.js, edge, static export, or platform-specific runtime;
- `cacheComponents`, output mode, base path, internationalization, image, and experimental configuration;
- deployment platform and supported capabilities; and
- existing lint, type, test, and build commands.

Search current official documentation scoped to that version when behavior is uncertain. In particular, verify asynchronous request APIs, route segment configuration, caching defaults, revalidation signatures, Server Actions, Proxy/Middleware naming, runtime support, and codemods.

Do not migrate Pages Router code to App Router opportunistically. Mixed applications need clear ownership and tests for navigation and shared assets across both routers.

## App Router Structure

Use route groups, private folders, and colocation to organize without changing URLs where supported. Keep special files semantically focused:

- `layout` for persistent shared UI and providers;
- `page` for route entry content;
- `loading` for segment fallback behavior;
- `error` for unexpected segment failures;
- `not-found` for missing resources;
- `route` for HTTP endpoints;
- `template` only when remount semantics are intentional; and
- metadata files or APIs for document and discovery metadata.

Layouts persist across navigation, so do not rely on them rerunning for request-sensitive authorization or transient state. Avoid putting unrelated data access in the root layout because it affects every route and can widen dynamic behavior.

Validate dynamic segments at the boundary. Decode and normalize parameters once, distinguish invalid input from an absent resource, and return the correct navigation or HTTP outcome.

## Server and Client Components

In App Router, pages and layouts are Server Components by default. Keep them server-side when they:

- fetch trusted data close to its source;
- use secrets, database clients, filesystem, or server-only dependencies;
- render noninteractive content;
- reduce shipped JavaScript; or
- compose server-rendered content and client interaction islands.

Use a Client Component when it needs state, event handlers, effects, browser APIs, client context, or client-only library behavior.

`'use client'` defines a module-graph boundary: its imports become eligible for the client bundle. Put it at narrow entry points and pass server-rendered content through composition where possible. Props crossing from server to client must satisfy React serialization rules and must contain only data the browser is allowed to receive.

Do not import a server-only module through a client graph. Use server-only guards supported by the project to make accidental imports fail early. Keep environment-neutral utilities free of `window`, server credentials, and runtime-specific side effects.

## Data Access

Fetch data at the layer that owns the route's rendering and security behavior.

- Call databases, CMS clients, or internal services directly from Server Components or server data modules when appropriate.
- Reuse an owned data-access function instead of calling the application's own Route Handler over HTTP from the server.
- Parallelize independent reads by starting them together or by composing sibling async components.
- Use `Suspense` and streaming around meaningful independent regions, not every function.
- Avoid sequential waterfalls created by awaiting data high in the tree before unrelated work starts.
- Return minimal data-transfer objects rather than full records.
- Validate untrusted responses and inputs where failure or abuse matters.

Place data authorization in a server data-access layer or the operation itself so every caller receives the same enforcement. A layout redirect and conditional navigation are user experience controls, not security boundaries.

## Caching and Rendering

Derive caching from data semantics:

- who may share the value;
- how stale it may be;
- what event makes it obsolete;
- whether read-your-writes is required;
- where the cache exists; and
- how invalidation reaches affected routes and clients.

Next.js caching behavior varies significantly by version and configuration. For current Next.js 16-style Cache Components, caching is opt-in when `cacheComponents` is enabled: use `'use cache'` at supported scopes, `cacheLife` for lifetime, and `cacheTag` plus the appropriate invalidation API. Older App Router versions use different `fetch`, route, data, and full-route cache defaults. Never combine examples across these models without version-matched documentation.

Cache only data safe to share for the cache key. Treat cookies, headers, identity, permissions, locale, tenant, and feature flags as potential personalization inputs. Never place per-user data in a shared cache unless identity is correctly part of its isolation model and the API explicitly supports it.

Use:

- static output for content stable and shareable at build/revalidation time;
- dynamic request rendering for request-specific or freshness-critical content;
- cached components/functions for deliberately reusable work; and
- streaming for dynamic regions that can arrive independently without breaking layout or accessibility.

Measure build duration, cache cardinality, invalidation fan-out, server latency, origin load, and stale behavior. Caching is a correctness decision as well as an optimization.

## Invalidation and Read-Your-Writes

After mutation, identify exactly which cached data and rendered routes are stale.

- Prefer domain-oriented tags over broad path invalidation where supported and maintainable.
- Use immediate expiry/read-your-writes mechanisms for a user who must see their own update.
- Use stale-while-revalidate behavior only when temporary staleness is acceptable.
- Use router refresh for the client/server view relationship it actually refreshes; do not assume it purges every server cache.
- Avoid invalidating the entire application for one entity.
- Prevent untrusted callers from invoking revalidation webhooks without authentication and replay controls.

Test create, update, delete, concurrent modification, failed mutation, browser back/forward, and a second session. Verify both the initiating user and other consumers observe the intended freshness.

## Server Actions and Server Functions

Treat every remotely invokable server function as a public mutation boundary even when referenced from a component.

- Authenticate and authorize inside the function or called data layer.
- Validate and normalize all arguments and `FormData` on the server.
- Use CSRF/origin protections provided by the framework and hosting model; verify custom proxying does not defeat them.
- Return structured expected outcomes for validation and business conflicts.
- Throw unexpected failures so the appropriate error boundary and telemetry handle them.
- Make retryable mutations idempotent or reject duplicates safely.
- Revalidate only after durable success.
- Redirect outside control flow that would accidentally catch framework navigation signals, according to the installed API.

Use native forms and progressive enhancement where possible. Preserve values, associate errors, expose pending state, prevent accidental duplicate submission, and keep a non-JavaScript path when the product requires it.

Do not use Server Actions as a general-purpose public API for external clients. Choose Route Handlers or an owned service contract when independent HTTP consumers need a stable protocol.

## Route Handlers

Use Route Handlers for externally callable HTTP endpoints, webhooks, browser-specific API needs, streaming responses, or protocol boundaries.

For each handler:

- support only intended methods;
- authenticate, authorize, validate, and rate-limit as required;
- define content type, status codes, errors, and cache headers;
- bound body size, processing time, and downstream concurrency;
- verify webhook signatures against the raw body where required;
- implement idempotency and replay protection for retried events;
- avoid leaking internal exceptions or secrets; and
- choose runtime APIs compatible with deployment.

Route Handlers are public-facing endpoints even when only the frontend currently calls them. Test them as contracts.

## Proxy and Middleware

Use the version-appropriate convention. In Next.js 16, `middleware` was renamed/deprecated in favor of `proxy` for its network-boundary role, with runtime differences; older projects may still require `middleware`.

Use this layer for lightweight request routing, redirects, headers, locale hints, or optimistic session checks when justified. Keep database access, heavy computation, and definitive authorization in server operations or data access.

Limit matchers precisely. Test static assets, framework internals, API endpoints, prefetch requests, bots, and redirect loops. Do not assume the same runtime modules are available as in application server code.

## Authentication and Authorization

Prefer a maintained authentication library compatible with the installed version unless the user explicitly requires a custom scheme.

- Set secure cookie attributes and session lifetime deliberately.
- Rotate, revoke, and refresh sessions safely.
- Centralize secure authorization in a data-access layer or domain operation.
- Return minimal DTOs containing only authorized fields.
- Recheck permissions for every Server Action and Route Handler.
- Prevent user existence, role, and resource identifiers from leaking through errors or cached content.
- Treat client context and hidden controls as presentation only.

Avoid expensive authentication queries repeated across one render. Use request-scoped deduplication where supported without turning authorization into an incorrectly shared cache.

## Error, Loading, and Missing States

Model expected outcomes as values: validation failures, conflicts, empty results, and ordinary dependency responses. Use `notFound` only for genuinely absent resources and redirect for deliberate navigation.

Let unexpected render failures reach the nearest useful `error` boundary. Scope boundaries so users retain navigation and unaffected work. Error boundary files are Client Components; log safely, present recovery, and do not expose server details or opaque digest data as user instructions.

Loading UI should reserve final layout, expose meaningful status, remain accessible, and avoid skeletons for responses too fast to perceive. Place Suspense boundaries around regions that can truly complete independently. A fallback should not hide navigation or essential context.

Test failures thrown before streaming, after streaming begins, in client events, in Server Actions, and in Route Handlers because transport and status behavior differ.

## Metadata, Search, and Sharing

- Give each route a descriptive title and metadata derived from authorized, cache-correct data.
- Use static metadata when fixed and dynamic generation only when needed.
- Define canonical URLs, robots behavior, sitemap, icons, manifests, and social images through supported conventions.
- Ensure dynamic metadata does not create avoidable request waterfalls.
- Escape or serialize structured data safely; never concatenate untrusted JSON-LD.
- Keep private, preview, parameterized, and duplicate routes out of indexes as required.

Metadata is part of rendering and caching. Verify output for direct requests, missing records, alternate locales, and deployed base URLs.

## Images, Fonts, Scripts, and Links

Use framework components when they provide correct optimization for the deployment model.

- Provide accurate image dimensions, responsive `sizes`, meaningful alt text, and priority only for likely critical images.
- Configure allowed remote image sources narrowly and protect transformation endpoints from abuse.
- Subset and preload only fonts needed for the initial route; verify fallback and layout stability.
- Load third-party scripts with a strategy matched to criticality, consent, and main-thread cost.
- Use framework links for internal navigation while preserving standard modifier-click, new-tab, focus, and URL behavior.

Do not assume files in `public` receive immutable caching; version cache-sensitive assets or configure delivery deliberately.

## Environment Variables and Runtime Boundaries

Treat variables exposed to the browser through public prefixes or inlined build configuration as public forever. Never place secrets, privileged endpoints, or private tokens there.

- Validate required server configuration at startup or build stage appropriate to the runtime.
- Understand whether a value is captured at build time or read at request time.
- Keep server and client configuration schemas separate.
- Do not log secret-bearing configuration.
- Verify Node, edge, serverless, worker, and static-export compatibility of every dependency.

Avoid custom servers unless a concrete requirement outweighs lost optimizations and platform portability.

## Accessibility and Navigation Experience

Preserve native elements and progressive enhancement across server and client rendering. Manage title, focus, announcements, and scroll on client navigation according to user needs. Ensure loading, errors, not-found, redirects, and streamed content are understandable with assistive technology.

Hydration must not replace correct server semantics, reorder focus, or render materially different content. Test without JavaScript where essential functionality is expected to remain available, and test keyboard operation before and after hydration.

## Performance

- Keep client boundaries narrow and inspect production client bundles.
- Fetch near the data source and parallelize independent work.
- Stream meaningful regions without causing layout shift or announcement noise.
- Avoid broad providers high in the tree when only a leaf needs context.
- Dynamically import expensive client-only features users may not open.
- Use Next.js image, font, script, and link behavior deliberately rather than mechanically.
- Measure server time, cache hits, RSC payload, HTML, JavaScript, hydration, Web Vitals, and route navigation.

Apply the frontend-performance skill for trace-driven optimization. Do not enable caching or partial rendering without a freshness and invalidation model.

## Testing

Use the repository's established stack. Cover:

- pure domain and data transformation logic;
- server data access, authorization, validation, and cache-key behavior;
- Client Component interaction and accessibility;
- Server Actions and Route Handlers as public boundaries;
- routing, parameters, metadata, loading, errors, and not-found states;
- direct request, refresh, client navigation, back/forward, and deep links;
- mixed-version or stale-client behavior after deployment; and
- production build and target-runtime execution.

Mock the network at an owned boundary rather than mocking Next.js internals broadly. Framework development mode differs in caching, rendering, effects, and optimization; validate production output before concluding.

## Deployment and Observability

Confirm the host supports the selected output, runtime, streaming, cache, image optimization, filesystem, and background behavior. Define build artifact ownership, migrations, environment promotion, release health, and rollback or roll-forward.

Use the supported instrumentation convention for server startup and telemetry. Observe route latency, server errors, actions, handlers, cache outcomes, downstream calls, Web Vitals, and deployment version with privacy-safe correlation.

Serverless and edge execution may have cold starts, time limits, regional data latency, connection constraints, and ephemeral filesystem. Test the deployed topology rather than assuming local Node behavior.

## Upgrades and Migration

For a version or router migration:

1. Read the official upgrade guide for every crossed major version.
2. Commit or isolate existing work before running supported codemods.
3. Inventory deprecated and experimental APIs, configuration, runtimes, and caching assumptions.
4. Apply mechanical changes separately from behavior changes.
5. Test caching, mutations, async request APIs, routing, metadata, errors, proxy/middleware, and deployment.
6. Inspect bundle and production build differences.
7. Remove compatibility shims only after all callers migrate.

Do not combine a router rewrite, design-system rewrite, state-library replacement, and major framework upgrade in one unreviewable change.

## Validation and Reporting

Before finishing:

1. Run formatting, linting, type checks, focused tests, and the production build supported by the repository.
2. Exercise success, pending, empty, expected-error, unexpected-error, unauthorized, and missing states.
3. Verify direct and client navigation, refresh, deep links, metadata, focus, and responsive accessibility.
4. Inspect client bundles for server leakage and unintended client expansion.
5. Test cache isolation, freshness, mutation invalidation, and another user/session where relevant.
6. Verify the target runtime and deployment behavior.
7. Review the diff for unrelated generated files or build artifacts.

Report:

```text
Next.js change:
- Installed Next.js/React versions and router:
- Runtime and deployment assumptions:
- Route and server/client boundaries:
- Data authority, caching, and invalidation:
- Authentication and authorization:
- Loading, error, and metadata behavior:
- Validation performed:
- Version-sensitive risks or unverified host behavior:
```

Never describe a change as statically rendered, dynamically rendered, cached, edge-compatible, or production-ready unless the version-matched build and runtime evidence support it.
