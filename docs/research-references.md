# Research References

This bibliography records the principal standards, specifications, and authoritative documentation consulted while developing the repository's skills. It provides research traceability without duplicating external documentation inside each `SKILL.md`.

**Last reviewed:** 2026-09-02

External guidance evolves. Before applying version-sensitive requirements, verify the current documentation for the project's actual language, framework, database, platform, and deployment environment. These references informed the skills; they do not imply endorsement by their publishers or replace project-specific requirements.

## Core

| Skill | Principal references | Research focus |
| --- | --- | --- |
| `algorithmic-efficiency` | [MIT OpenCourseWare: Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)<br>[Google SRE: Addressing Cascading Failures](https://sre.google/sre-book/addressing-cascading-failures/) | Complexity, data structures, bounded work, overload, and scaling behavior. |
| `clean-code` | [Google Engineering Practices: What to Look For in a Code Review](https://google.github.io/eng-practices/review/reviewer/looking-for.html)<br>[Google Engineering Practices: Small Changes](https://google.github.io/eng-practices/review/developer/small-cls.html) | Complexity, naming, cohesion, readability, scope, and maintainable changes. |
| `code-review` | [Google Engineering Practices: How to Do a Code Review](https://google.github.io/eng-practices/review/reviewer/)<br>[Google Engineering Practices: The Standard of Code Review](https://google.github.io/eng-practices/review/reviewer/standard.html)<br>[Google Engineering Practices: Writing Review Comments](https://google.github.io/eng-practices/review/reviewer/comments.html) | Review priorities, evidence, code health, severity, and constructive feedback. |
| `documentation` | [Diátaxis Documentation Framework](https://diataxis.fr/)<br>[Google Developer Documentation Style Guide](https://developers.google.com/style) | Tutorials, how-to guides, reference, explanation, clarity, and audience-oriented writing. |
| `error-handling` | [RFC 9457: Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc9457.html)<br>[Google SRE: Effective Troubleshooting](https://sre.google/sre-book/effective-troubleshooting/) | Stable error contracts, diagnostic context, failure classification, and recovery. |
| `seo` | [Google Search Essentials](https://developers.google.com/search/docs/essentials)<br>[Google: Creating Helpful, Reliable, People-First Content](https://developers.google.com/search/docs/fundamentals/creating-helpful-content)<br>[Google: SEO Starter Guide](https://developers.google.com/search/docs/fundamentals/seo-starter-guide)<br>[Google: Title Links](https://developers.google.com/search/docs/appearance/title-link)<br>[Google: Snippets and Meta Descriptions](https://developers.google.com/search/docs/appearance/snippet)<br>[Google: Spam Policies](https://developers.google.com/search/docs/essentials/spam-policies)<br>[Google: Canonical URLs](https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls)<br>[Google: Structured Data Guidelines](https://developers.google.com/search/docs/appearance/structured-data/sd-policies)<br>[Google: JavaScript SEO](https://developers.google.com/search/docs/crawling-indexing/javascript/javascript-seo-basics)<br>[RFC 9309: Robots Exclusion Protocol](https://www.rfc-editor.org/rfc/rfc9309.html)<br>[Sitemaps Protocol](https://www.sitemaps.org/protocol.html)<br>[Open Graph Protocol](https://ogp.me/) | Search intent, people-first content, search presentation, spam boundaries, crawl and index controls, rendering, canonicalization, structured data, social metadata, and measurement. |

## Frontend

| Skill | Principal references | Research focus |
| --- | --- | --- |
| `accessibility` | [W3C Web Content Accessibility Guidelines 2.2](https://www.w3.org/TR/WCAG22/)<br>[WAI-ARIA Authoring Practices Guide](https://www.w3.org/WAI/ARIA/apg/) | Accessible structure, semantics, keyboard use, focus, forms, and conformance testing. |
| `anti-ai-slop` | [GOV.UK: Government Design Principles](https://www.gov.uk/guidance/government-design-principles)<br>[GOV.UK: Identify user needs](https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/plan-manage-content/identify-user-needs/)<br>[U.S. Web Design System: Design principles](https://designsystem.digital.gov/design-principles/)<br>[Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines)<br>[W3C Web Content Accessibility Guidelines 2.2](https://www.w3.org/TR/WCAG22/) | User needs, task-oriented content, consistency without uniformity, visual hierarchy, platform conventions, responsive behavior, and accessible presentation. |
| `frontend-architecture` | [React: Thinking in React](https://react.dev/learn/thinking-in-react)<br>[Next.js App Router Documentation](https://nextjs.org/docs/app)<br>[Microsoft: Design Principles for Azure Applications](https://learn.microsoft.com/en-us/azure/architecture/guide/design-principles/) | Rendering and feature boundaries, dependency direction, composition, and evolution. |
| `frontend-performance` | [web.dev: Web Vitals](https://web.dev/articles/vitals)<br>[web.dev: Optimize Largest Contentful Paint](https://web.dev/articles/optimize-lcp)<br>[web.dev: Optimize Interaction to Next Paint](https://web.dev/articles/optimize-inp) | User-centered performance metrics, loading, responsiveness, and measurement. |
| `nextjs` | [Next.js Documentation](https://nextjs.org/docs)<br>[Next.js Production Checklist](https://nextjs.org/docs/app/guides/production-checklist)<br>[Next.js Self-Hosting Guide](https://nextjs.org/docs/app/guides/self-hosting) | Router and version awareness, server/client boundaries, rendering, caching, and deployment. |
| `react` | [React: Keeping Components Pure](https://react.dev/learn/keeping-components-pure)<br>[React: Lifecycle of Reactive Effects](https://react.dev/learn/lifecycle-of-reactive-effects)<br>[React: State as a Snapshot](https://react.dev/learn/state-as-a-snapshot) | Pure rendering, effects, state snapshots, identity, and component behavior. |
| `state-management` | [React: Managing State](https://react.dev/learn/managing-state)<br>[React: Choosing the State Structure](https://react.dev/learn/choosing-the-state-structure) | State ownership, normalization, derived state, lifting state, and reducer/context boundaries. |

## Backend

| Skill | Principal references | Research focus |
| --- | --- | --- |
| `api-design` | [RFC 9110: HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html)<br>[RFC 9457: Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc9457.html)<br>[OpenAPI Specification](https://spec.openapis.org/oas/latest.html) | Protocol semantics, methods, status codes, errors, schemas, compatibility, and contracts. |
| `authentication` | [NIST SP 800-63-4: Digital Identity Guidelines](https://pages.nist.gov/800-63-4/)<br>[RFC 9700: OAuth 2.0 Security Best Current Practice](https://www.rfc-editor.org/rfc/rfc9700.html)<br>[W3C Web Authentication Level 3](https://www.w3.org/TR/webauthn-3/) | Authenticators, sessions, federation, recovery, token security, and phishing resistance. |
| `authorization` | [OWASP Authorization Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html)<br>[Google Research: Zanzibar](https://research.google/pubs/zanzibar-googles-consistent-global-authorization-system/) | Deny-by-default policy, object and field checks, relationship-based access, and consistency. |
| `backend-architecture` | [Microsoft: Design Principles for Azure Applications](https://learn.microsoft.com/en-us/azure/architecture/guide/design-principles/)<br>[Microsoft: Domain Analysis for Microservices](https://learn.microsoft.com/en-us/azure/architecture/microservices/model/domain-analysis)<br>[Google SRE: Service Best Practices](https://sre.google/sre-book/service-best-practices/) | Domain boundaries, cohesion, coupling, service evolution, and operability. |
| `caching` | [RFC 9111: HTTP Caching](https://www.rfc-editor.org/rfc/rfc9111.html)<br>[AWS Builders' Library: Caching Challenges and Strategies](https://aws.amazon.com/builders-library/caching-challenges-and-strategies/)<br>[Redis: Cache-Aside Pattern](https://redis.io/docs/latest/develop/use-cases/cache-aside/) | Freshness, validation, invalidation, stampedes, capacity, and failure behavior. |
| `concurrency` | [The Go Memory Model](https://go.dev/ref/mem)<br>[Python: `asyncio` Task Groups](https://docs.python.org/3/library/asyncio-task.html#task-groups)<br>[Python: `asyncio` Synchronization Primitives](https://docs.python.org/3/library/asyncio-sync.html)<br>[C++ Core Guidelines: Concurrency](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-concurrency) | Happens-before relationships, structured task lifetime, synchronization, cancellation, and races. |

## Database

| Skill | Principal references | Research focus |
| --- | --- | --- |
| `database-design` | [PostgreSQL: Data Definition](https://www.postgresql.org/docs/current/ddl.html)<br>[PostgreSQL: Constraints](https://www.postgresql.org/docs/current/ddl-constraints.html) | Keys, relationships, constraints, nullability, invariants, and schema lifecycle. |
| `indexing` | [PostgreSQL: Indexes](https://www.postgresql.org/docs/current/indexes.html)<br>[PostgreSQL: Multicolumn Indexes](https://www.postgresql.org/docs/current/indexes-multicolumn.html)<br>[PostgreSQL: Index-Only Scans](https://www.postgresql.org/docs/current/indexes-index-only-scans.html) | Access paths, selectivity, composite and covering indexes, and write cost. |
| `migrations` | [PostgreSQL: Modifying Tables](https://www.postgresql.org/docs/current/ddl-alter.html)<br>[PostgreSQL: Explicit Locking](https://www.postgresql.org/docs/current/explicit-locking.html) | DDL behavior, compatibility, locking, phased rollout, and backfill risk. |
| `query-performance` | [PostgreSQL: Using `EXPLAIN`](https://www.postgresql.org/docs/current/using-explain.html)<br>[PostgreSQL: Performance Tips](https://www.postgresql.org/docs/current/performance-tips.html) | Execution plans, cardinality, scans, joins, I/O, statistics, and evidence-based tuning. |
| `sql` | [PostgreSQL: The SQL Language](https://www.postgresql.org/docs/current/sql.html)<br>[PostgreSQL: Transaction Isolation](https://www.postgresql.org/docs/current/transaction-iso.html)<br>[OWASP Query Parameterization Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Query_Parameterization_Cheat_Sheet.html) | Relational semantics, secure queries, transactions, locking, and isolation anomalies. |

## Architecture

| Skill | Principal references | Research focus |
| --- | --- | --- |
| `distributed-systems` | [Google SRE: Managing Critical State](https://sre.google/sre-book/managing-critical-state/)<br>[Google SRE: Addressing Cascading Failures](https://sre.google/sre-book/addressing-cascading-failures/)<br>[AWS Builders' Library: Timeouts, Retries, and Backoff with Jitter](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/) | Partial failure, consensus, retries, overload, coordination, and failure amplification. |
| `modular-design` | [Microsoft: Domain Analysis for Microservices](https://learn.microsoft.com/en-us/azure/architecture/microservices/model/domain-analysis)<br>[Parnas: On the Criteria To Be Used in Decomposing Systems into Modules](https://dl.acm.org/doi/10.1145/361598.361623) | Information hiding, cohesion, coupling, ownership, and module boundaries. |
| `scalability` | [Google SRE: Handling Overload](https://sre.google/sre-book/handling-overload/)<br>[Google SRE: Addressing Cascading Failures](https://sre.google/sre-book/addressing-cascading-failures/)<br>[Microsoft: Design for Scaling Out](https://learn.microsoft.com/en-us/azure/architecture/guide/design-principles/scale-out) | Capacity, horizontal scale, bottlenecks, load shedding, and graceful degradation. |
| `system-design` | [Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/)<br>[Microsoft: Design Principles for Azure Applications](https://learn.microsoft.com/en-us/azure/architecture/guide/design-principles/)<br>[Google SRE Book](https://sre.google/sre-book/table-of-contents/) | Requirements, quality attributes, boundaries, data, reliability, and system evolution. |

## Quality

| Skill | Principal references | Research focus |
| --- | --- | --- |
| `testing` | [Google Testing Blog: Test Sizes](https://testing.googleblog.com/2010/12/test-sizes.html)<br>[Martin Fowler: The Practical Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html) | Risk-based test portfolios, boundaries, feedback speed, and maintenance cost. |
| `unit-testing` | [Google Testing Blog: Test Sizes](https://testing.googleblog.com/2010/12/test-sizes.html)<br>[GoogleTest: Test Independence and Organization](https://google.github.io/googletest/primer.html) | Fast deterministic tests, behavior, isolation, assertions, and maintainability. |
| `integration-testing` | [Testcontainers Documentation](https://testcontainers.com/)<br>[Google Testing Blog: Test Sizes](https://testing.googleblog.com/2010/12/test-sizes.html) | Real dependency semantics, reproducible environments, isolation, and boundary fidelity. |
| `e2e-testing` | [Playwright: Best Practices](https://playwright.dev/docs/best-practices)<br>[Playwright: Test Isolation](https://playwright.dev/docs/browser-contexts)<br>[Playwright: Locators](https://playwright.dev/docs/locators)<br>[Playwright: Auto-Waiting](https://playwright.dev/docs/actionability) | Critical user journeys, resilient locators, deterministic synchronization, and diagnostics. |

## Security

| Skill | Principal references | Research focus |
| --- | --- | --- |
| `api-security` | [OWASP API Security Project](https://owasp.org/www-project-api-security/)<br>[OWASP API Security Top 10 — 2023](https://owasp.org/API-Security/editions/2023/en/0x11-t10/)<br>[OWASP REST Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html) | Object, property, and function authorization; resource abuse; SSRF; inventory; and upstream trust. |
| `dependency-security` | [NIST SP 800-218: Secure Software Development Framework](https://csrc.nist.gov/pubs/sp/800/218/final)<br>[SLSA Specification 1.2](https://slsa.dev/spec/v1.2/)<br>[OpenSSF Scorecard](https://scorecard.dev/) | Dependency trust, provenance, integrity, vulnerability response, and supply-chain controls. |
| `secure-coding` | [OWASP Application Security Verification Standard](https://owasp.org/www-project-application-security-verification-standard/)<br>[OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)<br>[NIST SP 800-218: Secure Software Development Framework](https://csrc.nist.gov/pubs/sp/800/218/final) | Threat boundaries, injection prevention, secrets, data protection, safe failure, and verification. |

## DevOps

| Skill | Principal references | Research focus |
| --- | --- | --- |
| `ci-cd` | [GitHub Actions: Secure Use Reference](https://docs.github.com/en/actions/reference/security/secure-use)<br>[SLSA Specification 1.2](https://slsa.dev/spec/v1.2/)<br>[NIST SP 800-218: Secure Software Development Framework](https://csrc.nist.gov/pubs/sp/800/218/final) | Pipeline trust boundaries, least privilege, immutable dependencies, artifacts, and provenance. |
| `deployment` | [Kubernetes: Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)<br>[Google SRE Workbook: Canarying Releases](https://sre.google/workbook/canarying-releases/)<br>[Google SRE: Reliable Product Launches at Scale](https://sre.google/sre-book/reliable-product-launches/) | Progressive rollout, readiness, compatibility, health verification, and recovery. |
| `docker` | [Docker: Building Best Practices](https://docs.docker.com/build/building/best-practices/)<br>[Dockerfile Reference](https://docs.docker.com/reference/dockerfile/)<br>[OCI Image Format Specification](https://github.com/opencontainers/image-spec/blob/main/spec.md) | Multi-stage builds, minimal runtime images, caching, secrets, users, signals, and portability. |
| `observability` | [OpenTelemetry: Signals](https://opentelemetry.io/docs/concepts/signals/)<br>[OpenTelemetry: Semantic Conventions](https://opentelemetry.io/docs/specs/semconv/)<br>[Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/) | Metrics, logs, traces, profiles, correlation, cardinality, dashboards, and alerts. |

## Maintaining This Bibliography

- Prefer standards bodies, primary research, and official project or vendor documentation.
- Link to stable specification or documentation landing pages when possible.
- Include a version in the link or title when requirements materially differ by version.
- Update the review date after checking affected links and guidance.
- Add a source only when it materially informs a skill; this is not intended to be an exhaustive reading list.
