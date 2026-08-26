---
name: api-design
description: Design, evolve, document, or review network API contracts with consistent resources, operations, schemas, errors, pagination, idempotency, compatibility, and operational semantics. Apply when an HTTP, RPC, event, or public service boundary changes; use implementation skills for internal-only function interfaces.
---

# API Design

Create contracts that consumers can understand, integrate with, and evolve against without depending on implementation details. Optimize for semantic consistency, explicit failure behavior, compatibility, security, and operability—not endpoint count or stylistic purity.

Follow the repository's existing protocol and conventions unless changing them is part of the request. Verify the deployed framework, API description version, gateway behavior, and consumer constraints before choosing syntax or defaults.

## Working Method

1. Identify consumers, business capabilities, trust boundaries, workflow, ownership, and compatibility obligations.
2. Model resources or operations independently of transport details.
3. Define identifiers, state transitions, invariants, authorization, consistency, and idempotency.
4. Map the model to protocol-native methods, status, schemas, errors, caching, and concurrency controls.
5. Specify limits, pagination, filtering, ordering, retries, and asynchronous completion.
6. Review privacy, abuse, observability, versioning, and deprecation.
7. Validate the contract with representative consumers, examples, schema checks, and compatibility tests.
8. Plan implementation and rollout so old and new consumers can coexist safely.

Do not redesign unrelated APIs or publish a breaking contract without explicit authorization and a migration plan.

## Non-Negotiable Guardrails

- **MUST** define observable semantics before selecting names or framework annotations.
- **MUST** validate and authorize every request at the resource and action level.
- **MUST** use protocol semantics consistently, including methods, status codes, cache controls, and retry signals.
- **MUST** bound payloads, collection sizes, query cost, request duration, and concurrency where abuse or exhaustion is possible.
- **MUST** define duplicate and retry behavior for mutations.
- **MUST NOT** expose internal stack traces, database models, secrets, or authorization-sensitive distinctions.
- **MUST NOT** treat generated documentation as proof that implementation matches the contract.
- **MUST NOT** make a breaking change under an unchanged compatibility surface.
- **SHOULD** make common operations unsurprising across the API.
- **SHOULD** prefer additive evolution and explicit deprecation over simultaneous version proliferation.

## Contract and Consumer Context

Record:

- internal, partner, public, or machine-to-machine consumers;
- supported SDKs, languages, and client lifetimes;
- synchronous, asynchronous, streaming, webhook, or batch interaction;
- latency, availability, freshness, ordering, and durability needs;
- authentication and authorization model;
- expected volume, payload, fan-out, and cost;
- data classification, tenancy, residency, and retention; and
- existing compatibility and deprecation policy.

An internal API can still have long-lived consumers and coordinated-change cost. A public API requires more conservative evolution, durable documentation, support policy, and abuse controls.

## Model Resources and Operations

For resource-oriented APIs, use stable nouns and hierarchical relationships that reflect ownership, not storage tables. Define:

- canonical resource name and immutable identifier;
- parent/tenant scope;
- representation and writable fields;
- lifecycle and valid transitions;
- creation, retrieval, listing, update, deletion, and custom operations;
- etag/version or concurrency token;
- retention, restoration, and purge behavior; and
- field-level visibility and authorization.

Use custom operations when the action has domain meaning that CRUD cannot express cleanly, such as `approve`, `cancel`, or `rotate`. Do not encode every action into a generic update that permits invalid transitions.

For RPC, name operations by intent and define request/response messages independently. For event APIs, events describe completed facts; commands request an action. Specify producer, consumer expectations, schema ownership, delivery, ordering, and replay.

## HTTP Semantics

Use methods according to RFC HTTP semantics and the actual operation:

- `GET` and `HEAD` are safe and must not perform business mutations.
- `PUT` replaces or creates the addressed representation with idempotent semantics.
- `PATCH` applies a defined partial-update format and must specify omitted/null behavior.
- `POST` creates subordinate resources or invokes non-idempotent/custom processing.
- `DELETE` removes or marks the addressed resource according to a documented lifecycle.

Do not use `GET` for state changes or return success status for failed business operations.

Choose status codes from protocol meaning: distinguish malformed input, unauthenticated identity, forbidden action, missing resource, conflict, precondition failure, rate limit, unsupported media, and server failure. Avoid revealing resource existence when authorization policy requires concealment.

Set `Location`, `Retry-After`, validators, content type, and cache headers where their semantics apply. Intermediaries act on status and headers even if clients ignore them.

## Request and Response Schemas

- Separate create, update, response, and internal persistence shapes when their permissions or lifecycles differ.
- Define required, optional, nullable, defaulted, read-only, and write-only fields precisely.
- State units, formats, ranges, timezone, precision, encoding, and normalization.
- Use stable machine identifiers; display names are not identifiers.
- Represent money with currency and exact decimal/minor-unit semantics.
- Use timestamps with explicit timezone and precision.
- Define unknown enum behavior and reserve expansion space for clients.
- Avoid polymorphism that generated clients cannot handle reliably.

Reject unknown fields when ambiguity or security warrants it; otherwise define whether they are ignored for forward compatibility. Never silently coerce dangerous or lossy values.

Responses should contain only fields the caller is allowed to observe. Do not return full database entities and rely on clients to ignore sensitive columns.

## Validation

Validate in layers:

1. transport and media type;
2. syntax and schema;
3. semantic field relationships;
4. identity and tenant scope;
5. resource authorization;
6. current-state preconditions; and
7. domain invariants at the authoritative write boundary.

Normalize only when unambiguous. Return field-level errors with stable machine codes and safe human messages. Server validation remains authoritative even when clients validate for usability.

Bound recursive structures, strings, arrays, files, decompressed size, numeric ranges, filters, sorting, and batch operations before allocating expensive resources.

## Errors

Use one consistent error envelope. For HTTP APIs, RFC 9457 Problem Details is a strong default when compatible with the repository.

Include:

- stable problem type or application error code;
- correct HTTP status;
- concise safe title/message;
- field violations when actionable;
- request or trace correlation safe to disclose; and
- retry guidance only when retry can help.

Do not expose stack traces, SQL, filenames, credentials, tokens, internal hosts, or authorization policy details. Log internal diagnostic context separately with privacy controls.

Distinguish expected client/domain outcomes from unexpected server faults. The same stable machine error should not change meaning between releases.

## Idempotency and Retries

Define retry behavior for every mutation.

- Naturally idempotent operations should produce the same intended state when repeated.
- For non-idempotent create/payment/job operations, support a caller-scoped idempotency key when retries are expected.
- Bind the key to identity, operation, and a canonical request fingerprint.
- Store the committed outcome long enough for the retry window.
- Reject reuse with a materially different request.
- Handle concurrent duplicates atomically.

An idempotency key does not make downstream side effects safe automatically. Propagate identity or use durable outbox/workflow mechanisms so email, billing, inventory, and events do not duplicate.

Clients need bounded retries, deadlines, exponential backoff, jitter, and status-specific policy. Do not label validation or permission failures retryable.

## Concurrency and Preconditions

Prevent lost updates when multiple clients modify a resource.

- Expose a version or strong validator.
- Accept conditional requests such as `If-Match` where appropriate.
- Return precondition failure or conflict with enough safe information to refetch and reconcile.
- Define whether PATCH operations merge, replace, or fail against changed fields.
- Keep invariant checks and writes atomic at the authority.

Last-write-wins is acceptable only when the domain explicitly tolerates it. Do not rely on client timestamps as trustworthy ordering.

## Collections

Every unbounded collection endpoint needs pagination and limits.

- Prefer opaque cursor/page tokens for mutable or large datasets.
- Bind tokens to filters, ordering, scope, and relevant snapshot state.
- Define deterministic ordering with a unique tie-breaker.
- Set default and maximum page size.
- Do not promise total counts when they are expensive or inconsistent unless required.
- Treat tokens as untrusted and tamper-resistant or server-validated.

Offset pagination is acceptable for small/stable data and random page access, but concurrent inserts/deletes can duplicate or skip results. Document its consistency behavior.

Filtering and sorting must use an allowlisted grammar, documented fields, types, case/null semantics, and bounded complexity. Do not pass client expressions directly to database or search engines.

## Partial Updates and Field Masks

Define whether omitted means unchanged, default, or cleared. Distinguish explicit `null` from absence. Use JSON Merge Patch, JSON Patch, field masks, or a purpose-built update schema consistently.

Allow only writable fields and validate cross-field invariants after applying the patch. Prevent mass assignment by mapping explicitly. Return the resulting representation or a documented minimal response.

## Batch and Asynchronous Operations

Batch APIs must define:

- maximum items and total size;
- atomic all-or-nothing versus per-item outcomes;
- ordering and duplicate behavior;
- authorization per item;
- idempotency; and
- rate/cost accounting.

For work that cannot finish within the synchronous deadline, create an operation/job resource. Return a stable operation identifier and status location, then define terminal states, progress, cancellation, expiry, result retrieval, and error retention. Polling must include backoff guidance; callbacks/webhooks require authentication, replay protection, retries, and observability.

## Events and Webhooks

Define event identity, type, occurrence time, producer, subject, schema version, and trace context. Consumers must handle duplicate delivery when at-least-once semantics apply.

For webhooks:

- sign the exact transmitted bytes with a rotatable key;
- include timestamp and event ID;
- enforce replay windows without dropping delayed legitimate events unexpectedly;
- retry with backoff and a published schedule;
- expose delivery history or recovery where product requirements warrant it;
- avoid following arbitrary redirects; and
- protect registration URLs against SSRF and ownership confusion.

Do not require consumers to infer an event by diffing two undocumented payloads.

## Authentication, Authorization, and Tenancy

Define credential type, token audience, scopes/permissions, expiration, and transport. Keep authentication distinct from authorization.

Check authorization for the operation, resource, relationship/ownership, tenant, and sensitive fields. Derive identity and tenant from trusted credentials or server-side context—not ordinary request fields.

Use field filtering and consistent not-found/forbidden behavior to prevent object enumeration. Include rate and quota dimensions per caller, user, tenant, IP, or expensive operation as the threat model requires.

Apply the authentication, authorization, or API-security skills for deeper implementation work.

## Compatibility and Versioning

Classify changes by consumer impact, not server convenience.

Usually additive:

- optional request fields;
- response fields clients are required to ignore safely;
- new endpoints or operations; and
- new enum values only if clients tolerate unknown values.

Usually breaking:

- removing/renaming fields or operations;
- changing types, formats, meaning, default, validation, or ordering;
- making optional input required;
- narrowing accepted values;
- changing authentication, errors, pagination, or timing assumptions; and
- adding enum values to closed generated types.

Prefer compatibility under one version. Introduce a new version only when incompatible semantics require it and define selection, support window, migration, telemetry, and retirement. Avoid versioning each endpoint independently without a coherent policy.

Deprecation needs an owner, announcement, replacement guidance, observable consumer usage, dates, and a shutdown gate. Never remove based only on documentation age.

## Description and Documentation

Keep the machine-readable description version compatible with repository tooling. OpenAPI, protobuf, GraphQL schema, or AsyncAPI should capture actual contract behavior, including security, examples, errors, and constraints.

- Lint and validate descriptions.
- Generate examples that satisfy schemas.
- Check implementation/contract drift.
- Run compatibility diffs in CI for governed APIs.
- Publish authentication, quickstart, workflows, limits, errors, and deprecation policy.

Do not rely exclusively on generated endpoint reference; consumers need conceptual lifecycle and failure guidance.

## Observability and Operations

Measure request rate, accepted/rejected work, latency distributions, status/error codes, payload sizes, rate limits, idempotency outcomes, dependency time, and version/consumer usage. Bound metric cardinality and redact sensitive fields.

Propagate correlation using standard trace context when available. Do not accept arbitrary external trace metadata as trusted authorization context.

Define SLOs, capacity limits, overload behavior, timeouts, and ownership. Load-test expensive filters, batches, large payloads, and failure paths.

## Validation and Review Output

Before finishing:

1. Walk primary, invalid, unauthorized, conflicting, duplicate, rate-limited, dependency-failure, and timeout scenarios.
2. Validate the machine-readable schema and representative examples.
3. Run contract, integration, security, compatibility, and load tests proportional to risk.
4. Test old consumers against the new provider and new consumers against the supported old provider where rolling deployment requires it.
5. Verify logs and errors do not leak secrets or sensitive data.
6. Confirm documentation, SDKs, gateway policy, and deprecation records remain aligned.

Report:

```text
API decision:
- Consumers, protocol, and compatibility promise:
- Resources/operations and invariants:
- Request, response, and error contracts:
- Authentication and authorization:
- Idempotency, concurrency, and retries:
- Pagination, limits, and asynchronous behavior:
- Alternatives and trade-offs:
- Validation, rollout, and deprecation:
```

Do not call an API RESTful, safe, compatible, or production-ready without demonstrating the relevant semantics.
