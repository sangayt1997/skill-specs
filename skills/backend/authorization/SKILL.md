---
name: authorization
description: Design, implement, test, or review access-control policies for actions, resources, fields, tenants, roles, attributes, and relationships. Apply when deciding what an authenticated or anonymous principal may do; use authentication guidance separately to establish identity.
---

# Authorization

Make every protected operation an explicit policy decision based on a trusted principal, intended action, authoritative resource, and relevant context. Deny by default, enforce least privilege, and keep policy consistent across APIs, jobs, events, administrative tools, and direct data access.

Authorization is domain logic with security consequences. Model it visibly, test it as a matrix, and keep enforcement close enough to the protected resource that alternate entry points cannot bypass it.

## Working Method

1. Inventory actors, resources, actions, fields, relationships, tenants, and administrative paths.
2. Identify policy owners, legal/business rules, segregation-of-duty constraints, and required freshness.
3. Build an access-control matrix from real workflows and abuse cases.
4. Select RBAC, ABAC, ReBAC, ACL, capability, or a deliberate combination based on the policy shape.
5. Centralize decision semantics while enforcing them at every entry point and data boundary.
6. Define default deny, inheritance, delegation, revocation, consistency, caching, and audit behavior.
7. Test positive, negative, cross-tenant, stale-policy, enumeration, and administrative scenarios.
8. Roll out policy changes with simulation, observability, rollback, and cleanup of obsolete grants.

Do not broaden access, create roles, or migrate policy authority beyond the requested scope without approval from the policy owner.

## Non-Negotiable Guardrails

- **MUST** deny when no explicit applicable allow rule exists.
- **MUST** authorize every request and every item/field whose access can differ.
- **MUST** derive principal and tenant from trusted authentication/server context, not ordinary request data.
- **MUST** enforce policy on the server or other trusted boundary; client checks are presentation only.
- **MUST** fail closed when required policy inputs or decision services are unavailable, except for explicitly approved availability trade-offs.
- **MUST** revoke access within the documented security window and invalidate affected caches.
- **MUST NOT** rely on object identifiers being unguessable.
- **MUST NOT** infer authorization from authentication, UI visibility, route reachability, or data possession alone.
- **MUST NOT** put long-lived mutable permissions into tokens without a freshness/revocation model.
- **SHOULD** log policy decisions and changes without leaking sensitive resource data.

## Decision Model

Represent a decision as:

```text
Can principal P perform action A on resource R in context C?
```

Inputs may include:

- immutable principal subject and identity provider;
- authentication assurance and time;
- tenant/organization membership;
- resource type, identifier, owner, parent, status, and classification;
- role, permission, group, attribute, or relationship;
- request channel, network, device, time, or risk;
- delegation and consent; and
- field or row being accessed.

Outputs should be allow or deny, with safe reason codes and optional obligations such as redaction, step-up authentication, approval, logging, or rate limits.

Keep identity attributes and resource attributes authoritative. Do not trust caller-submitted roles, owner IDs, prices, tenant IDs, or approval state.

## Policy Requirements

Create an access matrix covering principal categories against actions and resource conditions. Include:

- anonymous, normal, owner, collaborator, support, administrator, service, suspended, and deleted identities as relevant;
- create, list, read, update, delete, restore, export, share, approve, impersonate, and manage-permission actions;
- own versus another user's resource;
- same versus another tenant;
- active, archived, locked, sensitive, or regulated resource states;
- row and field restrictions; and
- emergency/break-glass conditions.

State who owns policy changes and how they are approved. Terms such as “admin” and “member” are insufficient until their permitted actions and scope are enumerated.

## Choose an Access-Control Model

### Role-Based Access Control

Use RBAC when permissions map stably to organizational job functions. Roles group permissions; they should not become arbitrary per-user exception bags.

- Separate role definition from assignment.
- Scope roles by organization, project, environment, or resource class.
- Prevent role explosion by modeling attributes/relationships where exceptions dominate.
- Define role hierarchy explicitly and test inherited permissions.
- Enforce mutually exclusive duties where required.

### Attribute-Based Access Control

Use ABAC when decisions depend on principal, resource, action, and environment attributes. Keep attributes authoritative, typed, bounded, and explainable. Complex boolean policy can become difficult to audit; define precedence and test combinations.

### Relationship-Based Access Control

Use ReBAC when access follows graph relationships such as owner, editor, viewer, parent organization, group membership, or shared folder ancestry. Define relation semantics, traversal depth, cycles, inheritance, consistency, and revocation. Relationship systems inspired by Zanzibar require careful external consistency and cache design; adopting the data model alone does not provide those guarantees.

### ACLs and Capabilities

ACLs are natural for per-resource grants but need lifecycle, scale, inheritance, and orphan cleanup. Capabilities/bearer links confer authority through possession; constrain scope, expiry, audience, use count, revocation, and leakage channels.

Combine models only when each owns a distinct policy dimension. Document conflict precedence; “any allow wins” can defeat explicit denial or tenant boundaries.

## Enforcement Placement

Use layered enforcement without duplicating policy meaning:

- gateway/router can reject missing identity or coarse scope;
- application/domain operation evaluates business action and resource context;
- data layer applies row/tenant constraints and prevents unscoped access;
- storage or platform controls limit blast radius for service identities; and
- UI reflects allowed actions but is never authoritative.

Every entry point—HTTP, RPC, WebSocket, queue consumer, scheduled job, CLI, admin tool, webhook, export, and background retry—must pass through the relevant policy.

Avoid scattered inline role comparisons. Expose purpose-specific checks such as `canEditInvoice(principal, invoice)` or a typed policy decision that uses one canonical action/resource vocabulary.

Do not load a resource after deciding based only on an untrusted ID. Retrieve it within tenant scope, then authorize against its authoritative attributes.

## Resource and Object-Level Authorization

For every object access:

- constrain lookup by authorized tenant/scope;
- verify ownership, relationship, status, and action;
- prevent indirect reference and enumeration;
- authorize parent and child semantics intentionally;
- recheck on mutation within the transaction when policy-relevant state can race; and
- authorize each item in bulk operations.

List authorization is not merely filtering an already exposed result. Push policy predicates into the query or retrieve from a security-filtered view so counts, pagination, sorting, timing, and aggregates do not leak inaccessible objects.

Batch endpoints must not authorize only the first item or accept partial access accidentally. Define atomic versus per-item behavior without revealing unauthorized resource existence.

## Field- and Operation-Level Authorization

Read and write permissions can differ per field.

- Build response DTOs from allowed fields; do not serialize the full entity and remove a few keys afterward when omissions are easy to miss.
- Allowlist writable fields to prevent mass assignment.
- Authorize changes based on old and proposed state.
- Protect derived fields, audit metadata, tenant, owner, status, price, role, and approval fields from ordinary updates.
- Define whether a denied field causes the request to fail or is omitted; silent dropping can hide client bugs.

GraphQL and flexible-query APIs require authorization on resolvers/fields and control of nested traversal. A permitted root query does not authorize every reachable field.

## Multi-Tenancy

Treat tenant isolation as a non-bypassable boundary.

- Derive active tenant from a trusted membership/session selection and verify membership.
- Include tenant scope in every resource lookup, unique constraint, cache key, job, file path, event, search index, and audit record.
- Prevent users from choosing an arbitrary tenant ID in request bodies.
- Scope service credentials and database access by tenant when risk warrants it.
- Test identifier collisions across tenants.
- Clear tenant-specific caches and state on tenant switch.

Cross-tenant administrative access needs explicit policy, purpose, audit, user visibility where required, and preferably time-bound elevation.

## Administrative and Support Access

Administrative authority should be granular, time-bounded where possible, and separate from normal user roles.

- Require stronger authentication and recent step-up.
- Apply least privilege and just-in-time elevation.
- Record requester, approver, reason, duration, actions, and affected resources.
- Separate read-support, user impersonation, permission management, billing, and destructive capabilities.
- Make impersonation visually obvious and prevent credential/security-setting changes unless explicitly approved.
- Protect audit logs from the same administrators being audited when separation of duties requires it.

Break-glass access needs a narrow emergency purpose, strong alerting, expiration, post-use review, and tested revocation—not a shared permanent superuser.

## Delegation, Sharing, and Consent

Define who may grant which permission, to whom, for what scope and duration. A principal cannot delegate authority they do not possess unless policy explicitly allows it.

- Validate the target identity and tenant.
- Prevent privilege escalation through role assignment or nested groups.
- Record grantor, source, reason, expiry, and inherited path.
- Notify affected users when appropriate.
- Support revoke and enumerate-all-access paths.
- Define ownership transfer atomically.

Public/share links must be unguessable, narrowly scoped, expiring when possible, revocable, and excluded from logs/referrers. Possession is authorization; treat leakage accordingly.

## Policy Changes, Freshness, and Caching

Authorization decisions can become stale when roles, relationships, resource state, subscription, employment, or risk changes.

Define:

- authoritative policy store;
- decision cache key including principal, action, resource, tenant, policy version, and relevant context;
- maximum staleness and revocation objective;
- invalidation/notification path;
- behavior during policy-store outage; and
- consistency between resource writes and permission updates.

Short token lifetime is not immediate revocation. For high-risk actions, consult current policy or use revocable/session-bound credentials. Avoid caching denies so long that newly granted access appears broken, and avoid caching allows beyond the acceptable revocation window.

In relationship systems, permission changes and resource content may require consistent snapshots so a user does not observe content under an older/newer relationship unexpectedly.

## Tokens and Claims

Tokens may carry stable coarse grants when bounded by audience, issuer, expiry, and revocation risk. Resource-specific mutable permissions often belong in an authorization service/store.

- Validate token cryptography and authentication separately.
- Treat claims as facts asserted by the trusted issuer only for their defined audience.
- Map external groups/roles through an approved local policy; do not accept arbitrary names as local admin roles.
- Keep scopes distinct from fine-grained resource authorization.
- Use the token subject, not a caller-provided user ID, for self-service operations.

Do not issue oversized tokens containing a complete mutable permission graph or personal data.

## Failure Behavior and Information Disclosure

Deny safely when policy evaluation fails, inputs are missing, or a resource cannot be scoped. Choose `403` versus concealed `404` behavior consistently with threat and consumer needs. Do not reveal which relation, role, tenant, or sensitive state caused denial to untrusted callers.

Internally, retain safe reason codes for support, audit, tests, and policy analysis. Distinguish authentication failure, insufficient assurance, authorization denial, and temporary policy-service failure without teaching attackers the policy graph.

## Audit and Explainability

Audit:

- policy and role definition changes;
- grants, revocations, group membership, delegation, and ownership transfer;
- privileged and break-glass decisions;
- repeated denials and cross-tenant attempts; and
- access to highly sensitive resources where required.

Record principal, action, resource reference, tenant, decision, policy version, safe reason, source, time, and correlation. Do not store sensitive object content or credentials unnecessarily.

Operators and policy owners need an explain path: which rules and relationships produced the decision at a given policy version. Explanation tooling must itself be authorized.

## Testing and Verification

Build tests from the access matrix, not only implementation branches.

- Positive tests prove intended access.
- Negative tests cover every action/resource combination not allowed.
- Test horizontal privilege escalation between peers and tenants.
- Test vertical escalation into admin/support operations.
- Test field overposting, hidden fields, list/search/count/export leakage, and nested resources.
- Test stale tokens, revoked roles, relationship removal, cache invalidation, and concurrent policy/resource changes.
- Test alternate protocols, jobs, bulk operations, and direct data paths.
- Property-test invariants such as “a user from tenant A never observes tenant B data” where practical.

Use representative policy snapshots and isolate test tenants. Do not make tests pass by granting broad fixtures.

For high-impact policy changes, run shadow evaluation comparing old and new decisions, investigate differences, then progressively enforce. Never log full sensitive requests during shadowing.

## Review Output

```text
Authorization decision:
- Principals, resources, actions, and tenants:
- Policy owner and access matrix:
- Access-control model and precedence:
- Enforcement points and data scoping:
- Delegation, administration, and lifecycle:
- Freshness, caching, and outage behavior:
- Audit and explainability:
- Positive/negative validation and residual risk:
```

Do not claim least privilege or tenant isolation because roles or middleware exist. Show the matrix, enforcement coverage, and negative test evidence.
