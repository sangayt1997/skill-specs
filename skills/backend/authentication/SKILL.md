---
name: authentication
description: Implement, review, or evolve identity verification, authenticators, sessions, federation, token validation, login, logout, recovery, and account-security flows. Apply when a system establishes or maintains who a caller is; use authorization guidance separately to decide what that identity may do.
---

# Authentication

Establish caller identity with assurance proportional to risk, then maintain that identity across requests without making credentials, sessions, or recovery paths the weakest link. Prefer maintained identity providers and protocol libraries over custom cryptography or hand-built federation.

Authentication does not grant permission. Produce an authenticated principal and assurance context; apply authorization independently at every protected operation.

## Working Method

1. Identify users, service identities, threats, regulated requirements, user experience, and required assurance.
2. Inspect existing identity provider, session/token model, trust boundaries, account lifecycle, and supported clients.
3. Choose authenticators and federation flows appropriate to phishing, theft, replay, and recovery risks.
4. Define registration, verification, login, step-up, session renewal, logout, recovery, and deprovisioning together.
5. Centralize protocol validation and credential handling in narrow, reviewed components.
6. Add rate controls, enumeration resistance, audit events, monitoring, and incident revocation.
7. Test normal, failed, replayed, expired, concurrent, compromised, and recovery scenarios.
8. Roll out compatibility changes without silently invalidating legitimate access or weakening assurance.

Do not change the account model, identity provider, password policy, or MFA requirement without product/security authority and a migration plan.

## Non-Negotiable Guardrails

- **MUST** use current, maintained libraries for password hashing, WebAuthn, OAuth, OpenID Connect, SAML, JWT, and cryptographic verification.
- **MUST** validate identity artifacts completely: signature/MAC, algorithm, issuer, audience, time bounds, purpose, nonce/state, and binding as applicable.
- **MUST** rotate session identifiers after authentication and privilege changes.
- **MUST** treat recovery, authenticator replacement, email change, and MFA reset as authentication ceremonies at least as protected as login.
- **MUST** rate-limit and monitor credential, OTP, recovery, and token endpoints.
- **MUST NOT** log passwords, private keys, session identifiers, access/refresh tokens, OTPs, reset tokens, authorization codes, or full identity assertions.
- **MUST NOT** invent cryptographic protocols, token formats, password hashes, or random generators.
- **MUST NOT** use OAuth access tokens as proof of user authentication unless the governing profile explicitly defines that use.
- **MUST NOT** rely on client UI, unsigned claims, request fields, or decoded-but-unverified tokens for identity.
- **SHOULD** offer phishing-resistant authentication for high-risk and privileged accounts.

## Identity and Assurance Model

Distinguish:

- **identifier**: how an account is referenced;
- **identity proofing**: evidence linking an account to a real-world subject when required;
- **authenticator**: something the subject controls to authenticate;
- **authentication assurance**: confidence from the ceremony and authenticator;
- **federation**: trusting assertions from another identity provider; and
- **session**: continuity of an authenticated interaction.

Select controls through a documented risk assessment. Consider account value, admin capability, personal/financial data, fraud, phishing, shared devices, accessibility, recovery availability, and regulatory assurance levels.

Do not collect real-world identity evidence when pseudonymous accounts satisfy the product. Identity proofing adds sensitive data, exclusion risk, fraud operations, retention, and legal obligations.

## Account Identifiers

Use an immutable internal subject identifier. Email addresses, phone numbers, usernames, and federated claims can change and may be reassigned.

- Normalize identifiers only according to provider/domain rules; email local-part rules are not universally safe to rewrite.
- Verify possession before treating contact channels as trusted.
- Enforce uniqueness atomically within the intended namespace.
- Separate display names from login identifiers.
- Avoid predictable public identifiers when enumeration increases risk.
- Define account merge, link, unlink, rename, and provider re-assignment behavior.

When linking a federated identity, require authentication to both the existing account and the new provider or an equivalent approved recovery path. Never link solely because email strings match.

## Password Authentication

When passwords are supported, follow the current applicable NIST/organizational policy rather than obsolete composition folklore.

- Permit long passphrases and all relevant characters without silent truncation.
- Block common, breached, context-specific, and compromised passwords with privacy-aware checking.
- Do not require arbitrary periodic changes absent compromise or governing policy.
- Avoid composition rules that encourage predictable substitutions unless required by a controlling standard.
- Support password managers, paste, and autofill.
- Show password requirements before submission and provide a reveal control.
- Rate-limit online guessing without enabling trivial account denial of service.

Store only a salted, adaptive password hash produced by a maintained implementation. Prefer the project's approved memory-hard algorithm, commonly Argon2id, with calibrated parameters; use scrypt, bcrypt, or PBKDF2 when platform, compliance, or compatibility requires it. Record algorithm and parameters per hash so they can be upgraded after successful authentication.

Keep a server-side pepper only when the threat model and secret-management system support rotation and incident handling; a lost pepper can invalidate all passwords. Never encrypt passwords for later recovery.

Use constant-time comparison through the library and perform a plausible hash for nonexistent accounts to reduce timing enumeration.

## Passkeys and WebAuthn

WebAuthn public-key credentials are origin/RP-scoped and can provide phishing-resistant authentication. Use a standards-compliant server library and browser API integration.

Registration must:

- generate a cryptographically random, single-use, expiring challenge bound to the session and ceremony;
- verify origin, RP ID, challenge, credential type, user presence, and required user verification;
- enforce allowed algorithms and attestation policy;
- store credential ID, public key, user handle, sign counter/backup information as needed, and metadata required by the library; and
- prevent credential reassignment across accounts.

Authentication must verify the challenge, origin, RP ID hash, signature, user presence/verification flags, credential ownership, and replay-relevant metadata. Treat counter anomalies as risk signals according to authenticator behavior rather than automatically locking out all syncable passkeys.

Support multiple authenticators and understandable naming/removal. A passkey recovery strategy is still necessary. Do not require attestation unless device provenance is a justified policy because it affects privacy and compatibility.

## Multi-Factor and Step-Up Authentication

Choose factors with independent attack resistance. Two passwords or password plus security question are not meaningful MFA.

Prefer phishing-resistant factors for administrators and high-risk actions. TOTP may be suitable where passkeys/security keys are unavailable; SMS and email codes have interception, account takeover, forwarding, and recovery weaknesses and should be used only at assurance levels that tolerate them.

- Protect factor enrollment and removal with recent sufficient authentication.
- Display and notify authenticator changes through trusted channels.
- Rate-limit OTP attempts and make codes short-lived, single-use, and bound to purpose/account.
- Store TOTP seeds encrypted with managed keys and restrict access.
- Provide recovery codes with high entropy, one-time use, secure storage, regeneration, and user guidance.
- Define remembered-device behavior, lifetime, revocation, and device binding.

Step up based on transaction risk, session age, authenticator assurance, device/context change, or privileged action. Bind transaction authorization to the exact action details when fraud risk requires it.

## Session Management

For browser applications, an opaque server-side session identifier in a secure cookie is often easier to revoke and protect than a long-lived self-contained browser token.

Session identifiers must be generated with cryptographic randomness, contain no meaningful data, and be stored only as protected lookup values where practical.

Cookies should use:

- `Secure` over HTTPS;
- `HttpOnly` when JavaScript access is unnecessary;
- the narrowest practical `Domain` and `Path`;
- `SameSite` appropriate to required cross-site flows; and
- an intentional persistent or session lifetime.

Regenerate identifiers after login, privilege change, account recovery, and other fixation-sensitive transitions. Define idle and absolute expiration, renewal, concurrent-device policy, user-visible session management, logout-current, logout-all, and administrative revocation.

Protect cookie-authenticated state changes against CSRF using same-site policy plus framework tokens/origin checks as appropriate. SameSite alone is not a universal CSRF solution.

Do not place session tokens in URLs. Clear cookies with matching attributes and invalidate server state on logout; client deletion alone is insufficient.

## Access and Refresh Tokens

Use access tokens only for their intended resource and audience. Keep them short-lived and least-privileged. Resource servers must validate the approved algorithm, signature/key, issuer, audience/resource, time claims, and token status/profile requirements.

Reject:

- algorithm confusion and unsupported algorithms;
- keys supplied from untrusted token headers without an allowlisted issuer process;
- wrong issuer or audience;
- expired/not-yet-valid tokens outside a documented clock skew;
- token types intended for another purpose; and
- missing required confirmation/binding claims.

Refresh tokens need secure client storage, rotation or sender-constraining where supported, reuse detection, bounded lifetime, audience/scope controls, revocation, and incident handling. A public browser client cannot keep a client secret.

Keep ID tokens, access tokens, refresh tokens, session cookies, and API keys distinct. An ID token describes an authentication event for its client; it is not generally an API bearer credential.

## OAuth 2.0 and OpenID Connect

Use current OAuth Security Best Current Practice and provider metadata.

- Use authorization code flow with PKCE for public clients and generally for confidential clients.
- Match redirect URIs exactly except standards-defined native loopback behavior.
- Generate transaction-specific high-entropy `state`, PKCE verifier/challenge, and OIDC `nonce` as required.
- Bind callback state to the initiating browser session and issuer.
- Defend authorization-server mix-up when multiple issuers are accepted.
- Use issuer metadata and pinned trust configuration; do not accept arbitrary discovery URLs.
- Validate ID token signature, issuer, audience/authorized party, expiration, issued-at policy, nonce, and authentication context as required.
- Retrieve user information only from the intended issuer and subject.

Do not use implicit or resource-owner-password flows for new systems. Do not create open redirectors or put tokens in browser URLs/logs. Use confidential-client authentication suited to the platform, preferring asymmetric methods when feasible.

Federation logout and session propagation are provider-specific and can be unreliable. Define local logout independently and document upstream/downstream behavior.

## Service and Workload Identity

Use platform workload identity, mutually authenticated TLS, or short-lived signed credentials rather than shared static API keys where available.

- Bind identity to workload, environment, audience, and purpose.
- Use automatic rotation and short lifetime.
- Keep human and machine identities separate.
- Do not embed credentials in images, repositories, configuration templates, or logs.
- Scope bootstrap credentials narrowly and remove them after enrollment.
- Define behavior under key rotation, clock skew, issuer outage, and credential compromise.

Authentication between services still requires authorization of each operation.

## Registration and Verification

- Require only data needed for the account and legal purpose.
- Verify contact channels with random, expiring, single-use tokens.
- Bind verification to the intended account and proposed value.
- Prevent replay and concurrent activation races.
- Use neutral responses where account enumeration matters.
- Rate-limit sign-up, verification resend, and promotional abuse.
- Record terms/consent evidence only when required and with appropriate retention.

Do not activate privileged roles based on a user-controlled domain string or email claim without an authoritative organizational process.

## Recovery and Account Changes

Recovery is a parallel login path and often the preferred attacker target.

- Return a consistent response and broadly similar timing whether the account exists.
- Send reset material through a previously verified side channel.
- Generate random, single-use, short-lived, purpose-bound tokens and store only protected representations.
- Do not change or lock the account until the claimant proves control.
- Require recent authentication for email, phone, password, factor, and recovery-channel changes when possible.
- Notify old and new channels of sensitive changes without exposing secrets.
- Revoke or offer revocation of existing sessions after recovery.
- Add delays or human review for high-risk recovery while providing a safe user path.

Security questions and knowledge easily learned from public records are weak authenticators. Customer support overrides need strong identity verification, separation of duties, auditing, and abuse monitoring.

## Enumeration and Abuse Resistance

Use generic external responses for login, registration, reset, and verification where identifier disclosure matters. Equalize processing enough to avoid simple timing differences without creating excessive denial-of-service cost.

Layer controls by account, device, network, tenant, and global behavior. Use progressive delays, proof-of-work/challenges, suspicious-login detection, credential-stuffing intelligence, and temporary protection based on risk. Avoid permanent account locks attackers can trigger cheaply.

Do not use CAPTCHAs as the only control or create inaccessible recovery paths. Monitor distributed low-rate attacks and successful login anomalies, not only per-IP failures.

## Errors and User Experience

Authentication UI must work with keyboards, assistive technology, password managers, and passkey platform flows. Preserve entered identifiers when safe, explain recoverable failures, and distinguish temporary service failure from invalid credentials without leaking account existence.

Do not tell users a password or token is “incorrect” after the server actually failed to validate it. Provide clear session-expired and step-up experiences that preserve unsaved work.

## Audit, Privacy, and Operations

Audit registration, verification, successful/failed login, MFA challenge, authenticator add/remove, recovery, credential change, token issuance/revocation, session termination, and privileged impersonation. Include actor, subject, time, outcome, assurance, safe device/network context, and correlation—never authenticators or tokens.

Protect authentication logs because they reveal user activity and attack intelligence. Set retention and access controls.

Monitor success/failure ratios, credential stuffing, recovery use, MFA bypass, token validation failures, issuer/key rotation, session anomalies, and provider availability. Define revocation and communication runbooks for compromise.

## Testing

Test:

- registration and duplicate identifiers;
- login success, wrong secret, nonexistent account, throttling, and concurrency;
- password hash upgrade and legacy compatibility;
- MFA enrollment, step-up, removal, recovery, and code replay;
- session fixation, expiry, renewal, CSRF, logout, and revocation;
- OAuth/OIDC state, nonce, PKCE, issuer, audience, redirect, code replay, and key rotation;
- WebAuthn challenge replay, origin/RP mismatch, wrong credential, and backup/counter behavior;
- reset token expiry, reuse, enumeration, and session invalidation;
- clock skew and dependency outages; and
- accessibility and supported-browser flows.

Use test identities and non-production providers. Never weaken production controls or copy live credentials to make tests pass.

## Completion Output

```text
Authentication decision:
- Actors, clients, and required assurance:
- Authenticators and federation profile:
- Session/token lifecycle and storage:
- Registration, step-up, logout, and recovery:
- Enumeration and abuse controls:
- Account and authenticator lifecycle:
- Audit, monitoring, and incident revocation:
- Validation performed and residual risk:
```

Do not claim MFA, phishing resistance, logout, or token validation from the presence of a library alone. Verify the entire ceremony and lifecycle in the deployed architecture.
