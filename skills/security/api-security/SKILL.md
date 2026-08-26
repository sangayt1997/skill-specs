---
name: api-security
description: Threat-model, implement, test, or review security controls for HTTP, RPC, GraphQL, webhook, and event APIs. Apply when an API exposes data or operations across a trust boundary; cover object/property/function authorization, resource abuse, inventory, SSRF, and unsafe upstream consumption.
---

# API Security

Secure every exposed object, field, operation, resource, and business flow according to its own risk.

## Working method

1. Inventory endpoints, versions, protocols, environments, data classes, callers, credentials, and upstream/downstream integrations.
2. Draw trust boundaries and abuse cases: unauthorized object/property/function access, automation, replay, injection, SSRF, exhaustion, and compromised upstream data.
3. Define authentication, authorization, validation, quotas, transport, error, logging, and lifecycle controls as testable requirements.
4. Reuse maintained security components and existing project policy; do not invent cryptography or token formats.
5. Test with multiple identities, roles, tenants, object ownership states, malformed inputs, and resource pressure.
6. Verify deployed configuration and inventory, not code alone.

## Guardrails

- Authentication never implies authorization. Check permission on every requested object and field at the operation boundary.
- Never accept tenant, owner, role, price, privilege, or other protected fields through unrestricted object binding.
- Reject unknown or disallowed fields when safe compatibility permits; use explicit input and output schemas.
- Do not put credentials or sensitive data in URLs, errors, logs, traces, or cache keys.
- Rate limiting is defense in depth, not an authorization control.
- Security testing against systems beyond the explicitly authorized target is prohibited.

## Identity and authorization

Validate credentials and tokens with the correct issuer, audience, signature algorithm, expiry, not-before, and intended token type. Support key rotation and reject algorithm/key confusion. Prefer short-lived scoped credentials and secure transport. For browser clients, account for cookie security and CSRF according to the authentication mechanism.

Enforce:

- **object-level authorization** whenever an identifier selects data;
- **property-level authorization** for every readable and writable field;
- **function-level authorization** for privileged operations;
- tenant isolation in queries and storage, not by obscuring identifiers.

Centralize policy while retaining resource context. Test deny-by-default, cross-user, cross-role, cross-tenant, archived/disabled objects, bulk operations, and alternate endpoints that reach the same effect.

## Inputs, outputs, and protocols

Validate shape, type, length, range, encoding, multiplicity, nesting depth, and content type before expensive processing. Parameterize database operations and encode output for its destination. Bound GraphQL depth/complexity and batching; constrain RPC message size and streaming lifetime.

Return only fields required by the contract. Use a stable safe error shape, avoid stack traces and authorization-sensitive distinctions, and retain a correlation ID. Ensure caches vary by all authorization-relevant inputs and do not store private responses publicly.

## Resource and business-flow abuse

Limit request size, decompression ratio, page size, query complexity, concurrency, processing time, response size, upload size, and downstream fan-out. Apply quotas at the meaningful identity—account, tenant, credential, device, or IP—with fair failure behavior.

Identify valuable workflows such as signup, purchase, reservation, verification, password reset, export, and messaging. Use workflow state validation, idempotency, replay protection, velocity controls, risk signals, and human challenges proportionately. Avoid controls that lock out legitimate users without recovery.

## Outbound calls and webhooks

Treat third-party API responses as untrusted: validate schema and bounds, use TLS verification, timeouts, bounded retries, circuit breaking, and least-privilege credentials. For user-influenced URLs, prevent SSRF with strict scheme/host/port policy, safe DNS/IP resolution across redirects, blocked private/link-local/metadata ranges, egress controls, and response limits.

Authenticate webhooks with a maintained signature scheme over raw bytes, constant-time verification, freshness, replay prevention, and key rotation. Acknowledge and process idempotently; never assume delivery exactly once.

## Inventory, configuration, and testing

Maintain an authoritative specification and inventory of hosts, endpoints, versions, owners, exposure, and retirement dates. Remove debug, legacy, and undocumented endpoints. Configure CORS narrowly; it is a browser read policy, not API authorization.

Test negative authorization with at least two identities, schema fuzzing, mass assignment, pagination/resource limits, duplicate/replayed requests, malformed credentials, SSRF redirects/DNS cases, and safe error behavior. Combine code review, automated analysis, dependency checks, and authorized dynamic tests.

Report the threat model, inventory scope, identity and authorization controls, schema/resource/business-flow protections, outbound trust, test evidence, deployed configuration assumptions, monitoring, and residual risks.
