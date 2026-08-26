---
name: secure-coding
description: Implement, modify, or review application code that crosses trust boundaries or handles sensitive data using threat modeling, safe input/output handling, least privilege, secret protection, and fail-safe behavior. Apply broadly to security-relevant code; use specialized auth or API skills for deeper domain policy.
---

# Secure Coding

Make the secure path the ordinary path and keep security claims tied to explicit threats and verification.

## Working method

1. Identify assets, actors, entry points, trust boundaries, privileges, sensitive data, abuse cases, and failure impact.
2. Inspect repository security conventions, supported versions, data classification, and existing maintained libraries.
3. Translate threats into testable requirements and enforce them at the boundary closest to the protected resource.
4. Implement least privilege, deny-by-default behavior, bounded resource use, and safe failure.
5. Review data flows and dangerous sinks; test misuse and negative cases as well as success.
6. Document assumptions, evidence, and unresolved risk without overstating assurance.

## Guardrails

- Never invent cryptographic algorithms, password hashing, token formats, escaping routines, or random generators.
- Never hardcode or log secrets; do not commit real credentials even temporarily.
- Validation and sanitization are context-specific. Encode at the output sink and parameterize interpreters.
- Authentication is not authorization; permission must be checked for the specific resource and action.
- Do not weaken certificate validation, signature verification, sandboxing, or security headers to make a test pass.
- Security review does not authorize scanning, exploitation, disclosure, production access, or unrelated remediation.

## Input and injection

Treat request data, files, headers, database content, queues, caches, environment variables, configuration, third-party responses, and serialized objects as untrusted when they cross a boundary. Validate type, structure, length, range, encoding, and allowed values before costly work.

Use parameterized SQL and safe APIs for commands, templates, paths, LDAP, expressions, and other interpreters. When dynamic identifiers are unavoidable, map them through strict allowlists. Encode output for its exact HTML, attribute, URL, JavaScript, CSS, shell, log, or protocol context; these encodings are not interchangeable.

Avoid evaluating untrusted code or deserializing into arbitrary types. For file handling, validate actual content and size, generate server-side names, prevent traversal and symlink races, store outside executable roots, scan when required, and serve with safe content disposition/type.

## Authorization and data protection

Enforce access at every object and operation boundary with trusted server-side context. Prevent mass assignment through explicit writable models. Minimize collected, returned, cached, and logged data. Classify retention and deletion requirements.

Use encryption in transit and at rest according to the threat model, with maintained libraries and managed keys. Encryption does not replace authorization. Compare authentication material in constant time through library primitives where relevant. Use cryptographically secure randomness for security tokens with adequate entropy and expiry.

Store passwords with a current purpose-built password hashing function and tunable work factors; never reversible encryption or general hashes. Keep keys separate from ciphertext and plan rotation, revocation, and loss.

## Network and server-side risks

For outbound requests, restrict destinations, protocols, ports, redirects, DNS/IP resolution, response size, and timeout to prevent SSRF and exhaustion. Block internal, link-local, loopback, and cloud metadata destinations unless explicitly required through a controlled broker. Treat upstream responses as hostile input.

Set bounded timeouts, concurrency, recursion/nesting, decompression, regex work, and memory. Retries must be bounded and idempotent. Avoid detailed errors that reveal internals while retaining correlation for operators.

For web code, use framework protections for output encoding, CSRF, cookies, content security policy, clickjacking, and CORS according to architecture. CORS is not access control. Keep redirect destinations allowlisted or relative.

## Secrets, logging, and failure

Load secrets through the project's approved runtime mechanism, scope them narrowly, rotate them, and prevent exposure in child processes, crash dumps, telemetry, URLs, and build artifacts. On suspected exposure, report it and follow the authorized rotation process; deleting a committed secret does not revoke it.

Log security-relevant outcomes with stable codes, actor/resource references safe for the audience, and correlation IDs. Avoid sensitive payloads and log injection; structure fields rather than concatenating untrusted text. Fail closed for security decisions, but design availability controls so attackers cannot cheaply cause global denial.

## Verification and output

Test valid, malformed, boundary, encoded, duplicate, unauthorized, cross-tenant, replay, timeout, and resource-exhaustion cases. Use type/static analysis, linters, secret and dependency scanning, focused fuzzing, and authorized dynamic testing as complementary evidence. Review generated code and configuration too.

Report assets and boundaries, threats considered, controls and their enforcement points, sensitive-data handling, negative tests and tools run, configuration/deployment assumptions, limitations, and prioritized residual risks.
