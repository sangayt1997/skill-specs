---
name: frontend-performance
description: Diagnose and improve user-perceived web performance across loading, rendering, interaction, navigation, assets, and browser resource use. Apply when frontend speed, responsiveness, visual stability, bundle cost, memory, or large collections matter; measure the actual bottleneck before optimizing.
---

# Frontend Performance

Improve the experience users actually receive on representative devices and networks. Base decisions on field data and reproducible traces, preserve correctness and accessibility, and optimize the critical bottleneck rather than a convenient proxy.

Performance is a product requirement spanning server response, delivery, browser parsing, style and layout, painting, JavaScript, third parties, data access, and interaction design. A smaller bundle is useful only if it improves the required outcome.

## Working Method

1. Define the user journey, population, device/network conditions, metric, percentile, and target.
2. Establish field and laboratory baselines before changing code.
3. Reproduce the slow experience with production-like content and constraints.
4. Break the metric into server, network, loading, main-thread, rendering, and application subparts.
5. Form one evidence-based hypothesis and choose the smallest safe intervention.
6. Measure the change under the same conditions and check correctness, accessibility, and regressions.
7. Validate in real-user data after release when authorized and available.
8. Add a budget, regression check, or observability improvement proportional to the risk.

Do not change architecture, dependencies, image quality, content, or analytics behavior beyond the user's scope merely to improve a synthetic score.

## Non-Negotiable Guardrails

- **MUST** compare before and after using the same test method, environment, route, data, and cache state.
- **MUST** optimize meaningful user journeys and distributions, not only a developer laptop or aggregate average.
- **MUST** preserve accessibility, security, content accuracy, visual intent, and interaction semantics.
- **MUST** distinguish field measurements from laboratory estimates and synthetic proxies.
- **MUST NOT** claim an improvement from source diff, byte reduction, or one noisy run alone.
- **MUST NOT** lazy-load above-the-fold critical content or the likely Largest Contentful Paint resource without evidence.
- **MUST NOT** preload or prefetch broadly; speculative work competes with current-page resources and user bandwidth.
- **MUST NOT** memoize, virtualize, cache, debounce, or move work to a worker before locating the cost and evaluating semantics.
- **SHOULD** remove unnecessary work before making it faster.
- **SHOULD** use performance budgets to prevent regression after a demonstrated fix.

## Define the Performance Requirement

Specify:

- journey and route;
- user population and geography;
- device class, memory, CPU, browser, network, and data-saver conditions;
- cold or warm navigation and cache state;
- content and account state;
- metric and percentile;
- target and business reason; and
- required comparison window.

Core Web Vitals currently focus on Largest Contentful Paint (loading), Interaction to Next Paint (responsiveness), and Cumulative Layout Shift (visual stability). When evaluating formal thresholds, verify the current official definitions; the commonly used “good” targets are LCP at or below 2.5 seconds, INP at or below 200 milliseconds, and CLS at or below 0.1 at the 75th percentile.

Add journey-specific measures such as time to search results, checkout readiness, editor input latency, media start, route transition, or job completion. A page can pass generic metrics and still fail its primary task.

## Field and Laboratory Evidence

Use both where possible:

- **Real-user monitoring** reveals actual devices, networks, caches, geography, third parties, and long-tail experiences.
- **Lab testing** provides controlled reproduction, detailed traces, and rapid comparisons.
- **Synthetic monitoring** catches availability and performance regressions on stable scripted journeys.
- **Profiling** attributes CPU, rendering, allocation, and network cost to work.

Segment field data by route, release, device, connection, geography, browser, logged-in state, and experiment when sample size permits. Report sample size and avoid conclusions from mixed populations.

Laboratory tools can throttle CPU and network but do not perfectly reproduce real hardware or scheduling. Run enough repetitions, use medians or distributions, disclose variability, and avoid comparing a cold baseline with a warm result.

## Diagnose Before Optimizing

For slow loading, inspect:

- redirects, DNS, connection, TLS, server time, and content delivery;
- discovery time, priority, queueing, transfer, and decode of the critical resource;
- render-blocking CSS, fonts, scripts, and imports;
- client-side data waterfalls and hydration; and
- cache headers and compression.

For slow interaction, inspect:

- input delay from queued main-thread work;
- event-handler duration and synchronous state work;
- rendering delay from style, layout, paint, and compositing;
- long tasks, repeated renders, forced synchronous layout, and excessive DOM; and
- third-party callbacks, observers, and timers.

For layout shift, identify the shifting element and what inserted or resized before it. Attribute each shift to unsized media, fonts, ads, embeds, client-rendered content, animations, or late style changes.

For memory or long-session degradation, compare heap growth across repeated actions, detached DOM, listener/timer cleanup, cache bounds, retained closures, workers, media, and graphics resources.

## Critical Rendering Path

Deliver useful HTML and essential styles early.

- Avoid redirects and sequential server dependencies before the first byte.
- Let the browser discover critical resources from HTML where possible.
- Inline only genuinely critical, bounded content when it reduces delay without harming caching or security policy.
- Split noncritical styles while preventing flashes, missing semantics, or duplicated rules.
- Defer scripts not required for initial rendering or interaction.
- Avoid client data fetching for content the server already had unless freshness or personalization requires it.

Server rendering may improve content visibility while hydration still blocks interaction. Measure both. Progressive enhancement and native controls can keep essential journeys usable before JavaScript is ready.

## Largest Contentful Paint

Identify the actual LCP element in representative field and lab samples; it can change by viewport or content.

Improve its major subparts:

- **server response**: remove redirects, cache appropriate HTML/data, reduce server work, and use nearby delivery;
- **resource load delay**: expose the resource in initial HTML, avoid lazy loading it, and apply fetch priority or preload only when justified;
- **resource duration**: right-size, compress, and serve an efficient format from an appropriate origin; and
- **element render delay**: remove blocking CSS/JavaScript, avoid client-only discovery, and reduce main-thread contention.

Do not improve LCP by substituting lower-value content or hiding the real hero. Preserve image quality required by the product and use responsive candidates rather than sending desktop dimensions to every device.

## Interaction Responsiveness

An interaction includes input delay, processing, and presentation of the next frame.

- Keep handlers focused; defer unrelated analytics, persistence, and secondary UI work.
- Break long tasks at meaningful boundaries so the browser can process input and render.
- Avoid large synchronous parsing, cloning, sorting, serialization, and validation on the main thread.
- Reduce render scope and DOM/style work caused by a state update.
- Yield between chunks for interruptible background work.
- Use a worker for CPU-heavy pure computation only when transfer, serialization, cancellation, and lifecycle costs are acceptable.
- Provide immediate feedback for longer operations without falsely indicating completion.

Debouncing changes when work occurs and can drop intermediate input; throttling limits frequency. Choose them only when those semantics match the task. Do not debounce direct control feedback until it feels broken.

## Visual Stability

Reserve the final space for images, video, embeds, ads, banners, and asynchronously loaded components. Provide intrinsic dimensions or aspect ratio. Insert nonessential content below or outside the current viewport when possible.

Use font metrics, appropriate fallback fonts, and loading strategy to minimize text reflow. Animate transforms and opacity instead of layout properties where the visual design permits. User-initiated shifts may be expected, but controls must not move between pointer-down and activation.

Skeletons should match final geometry and not create more work than the content. Do not use indefinite placeholders that hide stalled requests.

## JavaScript Cost

Evaluate transfer, parse, compile, execution, memory, and scheduling—not minified bytes alone.

- Remove unused features and dependencies before fine-grained splitting.
- Import narrow, tree-shakeable entry points when supported.
- Split at routes or expensive features users may never open.
- Avoid waterfalls of tiny chunks and repeated shared dependencies.
- Audit transpilation and polyfills against the supported-browser policy.
- Keep server-only code and secrets out of client graphs.
- Delay nonessential initialization and hydration.
- Replace heavyweight generic libraries only when measured savings exceed migration and maintenance cost.

Inspect production artifacts and source maps with the project's bundle analyzer. Source imports may compile differently than expected, and a lazy import can still be eagerly pulled through another path.

## Rendering and DOM Work

- Keep DOM size proportional to visible or semantically required content.
- Batch reads and writes to avoid layout thrashing.
- Avoid measuring layout immediately after mutations in repeated loops.
- Scope style invalidation and avoid selectors or global mutations that affect large subtrees.
- Use containment only after checking layout, accessibility, sticky positioning, and rendering effects.
- Schedule visual updates with the browser's rendering cycle where appropriate.
- Clean up observers, listeners, animations, portals, timers, and retained nodes.

Framework rerenders are not automatically DOM work; profile whether components execute, reconciliation changes nodes, and browser rendering is triggered. Optimize the stage that consumes time.

## Lists and Large Collections

Start with pagination, incremental disclosure, or bounded result sets when they fit the product. Virtualize only when rendering the full collection causes measured cost.

For virtualization:

- preserve keyboard navigation, focus, accessible position/count semantics, find-in-page expectations, and screen-reader usability;
- maintain stable item identity;
- handle dynamic heights and resize without scroll jumps;
- overscan enough for smooth movement without recreating the original cost;
- restore scroll and selection across navigation; and
- test rapid scrolling, filtering, insertion, and responsive changes.

Virtualization trades DOM size for implementation, accessibility, measurement, and state complexity. Do not apply it to small lists.

## Images, Video, and Embeds

- Provide responsive image candidates and accurate `sizes`.
- Choose formats based on visual content, transparency, animation, browser support, and encoding cost.
- Size assets near their rendered dimensions and preserve aspect ratio.
- Eagerly load the likely critical image; lazy-load below-viewport media.
- Use thumbnails, poster images, and user initiation before loading expensive players where appropriate.
- Isolate and defer embeds while preserving a useful accessible fallback.
- Configure long-lived caching for content-addressed media.

Image optimization services need correct cache keys, quality controls, origin protection, and limits against arbitrary transformation abuse.

## Fonts

Minimize families, weights, styles, character sets, and origins. Prefer modern compressed formats and subset only when language coverage remains correct.

- Preload only fonts required immediately and ensure the request matches CSS to prevent duplicate transfer.
- Set a deliberate `font-display` policy from content and brand needs.
- Match fallback metrics where possible to reduce shifts.
- Cache immutable versioned font files.
- Verify CORS, privacy, and licensing.

System fonts can be the best performance choice but are not universally interchangeable with a required brand or reading experience.

## CSS

- Remove unused global styles based on production paths, not a single page crawl.
- Keep critical styles discoverable early.
- Split route-specific CSS without duplicating foundational rules.
- Avoid unbounded generated class output.
- Profile expensive effects such as large blur, filters, shadows, and painting before changing them.
- Respect reduced motion and avoid continuous off-screen animation.

Runtime styling can add script and render work; build-time extraction can add tooling and ordering complexity. Measure within the chosen architecture.

## Network, HTTP, and Caching

Define each resource's freshness and identity.

- Cache content-addressed static assets immutably.
- Revalidate mutable documents and data according to correctness needs.
- Compress textual assets with supported encodings.
- Reduce origins and connection setup on critical paths.
- Use preconnect only for a few known critical cross-origin connections.
- Use preload for current-page resources whose discovery is demonstrably late.
- Use prefetch or prerender for likely future navigation only with privacy, bandwidth, freshness, and server-load controls.

Avoid redundant client waterfalls: parallelize independent requests, batch chatty access when justified, and start required work at the earliest authoritative layer. Cancellation prevents obsolete navigation or search work from consuming resources.

Service workers can improve repeat visits and resilience but add cache versioning, update, storage, privacy, and stale-content risks. Do not add one solely to obtain a performance badge.

## Third-Party Code

Inventory tag purpose, owner, data access, transfer, main-thread cost, network origins, loading phase, consent condition, and failure behavior.

- Remove unused or duplicate tags.
- Load nonessential scripts after critical content or interaction.
- Gate code on consent where required, not merely outgoing requests.
- Sandbox untrusted embeds and limit capabilities.
- Establish budgets and review expiration dates.
- Test slow, blocked, and failed third parties.

Self-hosting can improve control but transfers security, update, licensing, and caching responsibility. A tag manager does not eliminate runtime cost or governance.

## Data Fetching and Client Caches

- Avoid sequential fetches when dependencies are independent.
- Deduplicate identical in-flight work.
- Cache only with explicit freshness, invalidation, identity, and memory bounds.
- Cancel obsolete work and suppress stale responses.
- Paginate or stream large responses.
- Request only data used by the current experience.
- Keep optimistic updates correct under failure and concurrent changes.

Moving requests earlier can improve latency but may waste bandwidth or expose private data. Prefetch only from a justified probability and benefit.

## Memory and Long-Lived Sessions

Test repeated navigation, open/close, edit, upload, and reconnect cycles. Look for monotonic growth after garbage collection.

Bound application caches, histories, logs, object URLs, decoded media, canvases, and offline data. Dispose subscriptions, listeners, observers, timers, workers, sockets, and graphics contexts. Avoid retaining large data through closures or global stores after the owning route is gone.

Memory pressure can cause tab eviction, crashes, garbage-collection pauses, and degraded responsiveness, especially on mobile. Include long-session testing for dashboards, editors, and single-page applications.

## Performance Budgets

Set route- and journey-specific budgets for outcomes and contributing resources, such as:

- field percentile for LCP, INP, CLS, and product measures;
- initial and incremental JavaScript/CSS transfer and execution;
- image, font, and third-party cost;
- main-thread long tasks and interaction duration;
- request count or critical-path depth; and
- DOM or memory limits where demonstrated risk exists.

Use budgets in CI for deterministic artifacts and lab regressions, but account for test variance. A budget failure should identify the responsible change and require review, not encourage gaming through arbitrary threshold increases.

## Validation

For every optimization:

1. Record the baseline, trace, and hypothesis.
2. Run the existing functional and accessibility tests.
3. Repeat controlled measurements across representative device/network profiles.
4. Compare distributions or enough runs to account for noise.
5. Inspect secondary metrics for regressions and resource trade-offs.
6. Test cold load, warm load, navigation, back/forward, failure, and long-session behavior as relevant.
7. Verify production build output rather than development mode.
8. Monitor field results after rollout and be prepared to revert if user outcomes worsen.

Do not use Lighthouse score alone as the result. Report raw metrics, conditions, tool/version, uncertainty, and field limitations.

## Performance Report

```text
Frontend performance change:
- User journey and population:
- Metric, percentile, and target:
- Baseline and measurement conditions:
- Bottleneck and supporting trace:
- Change and expected mechanism:
- Before/after results and variability:
- Correctness/accessibility checks:
- Secondary effects and trade-offs:
- Field validation or rollout plan:
- Budget or regression prevention:
```

If evidence is inconclusive, say so and keep the simpler implementation. Performance work is complete when the user-relevant outcome is demonstrated, not when an optimization pattern has been applied.
