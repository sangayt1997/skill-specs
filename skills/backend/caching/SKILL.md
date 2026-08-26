---
name: caching
description: Design, implement, diagnose, or review caches with explicit keys, freshness, invalidation, consistency, capacity, stampede protection, security, and failure behavior. Apply when reusing computed or fetched data can improve latency, cost, or availability; measure reuse and origin impact before adding a cache.
---

# Caching

Use caches as bounded, disposable replicas of an authoritative source. Improve a measured latency, cost, or capacity problem without creating silent correctness, privacy, or outage risks.

Caching changes system behavior under hit, miss, stale, eviction, invalidation, cold start, and cache outage modes. Design and test every mode; a fast warm-cache benchmark is insufficient.

## Working Method

1. Define the user/SLO problem, baseline, origin limit, workload distribution, and expected reuse.
2. Identify the authority, acceptable staleness, consistency-sensitive operations, and security scope.
3. Choose placement and pattern with the smallest operational cost.
4. Specify canonical key, value schema, TTL, invalidation, eviction, capacity, and failure behavior.
5. Protect origin and cache from stampedes, hot keys, poisoning, and unbounded cardinality.
6. Instrument hits, misses, staleness, origin load, latency, evictions, and errors.
7. Test warm, cold, partial, expired, invalidated, unavailable, and recovery modes.
8. Roll out gradually and retain a safe disable/bypass path.

Do not add or widen caching when the data's correctness semantics are unknown. Prefer eliminating waste or optimizing the authority when reuse is low.

## Non-Negotiable Guardrails

- **MUST** identify the source of truth and make cache entries reconstructable or safely discardable.
- **MUST** include every input affecting value, authorization, tenant, locale, representation, and version in the key or isolation boundary.
- **MUST** define maximum staleness and invalidation behavior.
- **MUST** bound memory/storage, key count, value size, TTL, fill concurrency, and origin fallback traffic.
- **MUST** protect sensitive cached data in transit, at rest, in memory, and from cross-principal reuse according to its classification.
- **MUST NOT** use cached authorization, account status, inventory, money, or other critical state beyond its documented security/correctness window.
- **MUST NOT** make a cache the only copy of durable data.
- **MUST NOT** flush a shared production cache broadly without impact analysis and authorization.
- **SHOULD** coalesce concurrent misses and jitter expiration where synchronized refill can overload the origin.
- **SHOULD** make bypass and degradation observable and reversible.

## Justify the Cache

Measure:

- repeated access probability and key popularity distribution;
- origin latency, throughput, quota, and cost;
- value computation cost and size;
- read/write ratio and update frequency;
- acceptable stale/incorrect window;
- expected hit ratio by traffic cost, not only request count;
- cold-start and cache-loss origin capacity; and
- operational cost and failure-domain change.

Do not cache a high-cardinality workload with mostly unique requests. A low-cost origin lookup may be safer than another distributed system. Estimate benefit:

```text
expected latency ≈ hit_ratio × hit_latency + miss_ratio × miss_latency
origin load      ≈ admitted requests × miss_ratio × amplification
```

Account for fill, invalidation, replication, serialization, and cache errors.

## Choose Placement

### Client and HTTP Caches

Use browser, CDN, reverse-proxy, or intermediary caches for HTTP representations when protocol semantics permit. Define `Cache-Control`, validators, `Vary`, and surrogate behavior according to RFC 9111 and the deployment.

- `no-store` prevents storage; `no-cache` requires validation before reuse and does not mean “do not store.”
- Use `private` for user-specific responses and explicit shared-cache directives only when safe.
- Include every content-negotiation dimension in `Vary` without creating unbounded variants.
- Use strong/weak validators according to representation semantics.
- Version immutable static resources and cache them long-term.

Never cache authenticated responses in a shared layer unless cache keys and directives deliberately isolate them. Test actual CDN/gateway behavior, not only origin headers.

### In-Process Cache

Provides lowest latency and no network dependency, but every instance has separate contents, memory cost, cold start, and invalidation delay. Fleet growth multiplies origin fills. Use for small, bounded, tolerant data; define per-process eviction and warming.

### Shared Remote Cache

Improves coherence and aggregate reuse, but adds network latency, a new service/failure domain, serialization, connection pools, and operational work. Size and secure it like production infrastructure.

### Near Cache / Multi-Level

Combines local and shared layers but multiplies freshness and invalidation states. Use only when measured need justifies it; keep TTLs and versioning coherent and test stale local entries after shared invalidation.

## Choose a Pattern

### Cache-Aside

Application reads cache, loads origin on miss, then writes cache. Simple and widely applicable, but misses can stampede and writes need invalidation/update.

### Read-Through / Inline

Cache loads the origin on miss. Centralizes behavior but can hide origin cost, credentials, and failure. Verify key and negative-cache semantics.

### Write-Through

Update authority and cache synchronously. Can improve read freshness but makes cache part of write availability and needs atomic/ordering strategy.

### Write-Behind

Cache accepts writes before the authority. This is a durable buffering system, not ordinary caching. It needs persistence, ordering, retry, conflict, replay, recovery, and data-loss analysis. Do not use it casually.

### Refresh-Ahead

Refresh popular entries before expiry. Bound speculative refresh and stop refreshing unused keys. A soft TTL/hard TTL model can serve stale while refreshing or during a brief origin failure when the domain permits it.

## Cache Keys

Keys are correctness and security contracts.

Include as relevant:

- namespace/application/environment;
- schema and behavior version;
- resource and immutable identity;
- tenant, user, role, permission scope, or audience;
- locale, currency, timezone, feature/config version;
- query/filter/sort/page and representation format; and
- source version or consistency token.

Canonicalize inputs deterministically. Avoid ambiguous concatenation, unstable object serialization, raw secrets, personal data, or attacker-controlled unbounded strings. Hash long/sensitive key material with a suitable non-secret/secret construction according to threat needs while retaining safe diagnostic tags.

Do not let two operations reuse a key merely because their current response shapes match.

## Values and Serialization

- Store the minimum useful representation.
- Version the value schema.
- Bound value size before allocation and decompression.
- Use deterministic, maintained serializers.
- Handle old, corrupt, unknown, and poison values as misses with safe eviction/quarantine.
- Preserve needed freshness, source version, etag, and negative-result metadata.
- Avoid language-native object serialization that can execute code or break across releases.

Encryption does not fix incorrect tenant keys or unauthorized readers. Minimize sensitive data and restrict cache administration/debug tooling.

## Freshness and TTL

Choose TTL from the maximum tolerated staleness, source update rate, invalidation reliability, origin capacity, and cache size—not an arbitrary round number.

- **hard TTL**: latest point an entry may be served without explicit domain exception;
- **soft TTL**: point to refresh while a stale value may remain temporarily usable;
- **jitter**: randomized expiry to prevent synchronized misses;
- **sliding TTL**: extends on access and can retain hot stale data indefinitely; use only when semantics allow;
- **no expiry**: requires reliable versioning/invalidation and bounded eviction; rarely safe by default.

Do not extend a hard correctness window merely because origin is failing. Stale-if-error needs an approved stale bound and visible degraded state.

## Invalidation and Updates

Name every event that makes an entry stale and how it reaches all cache layers.

Options:

- delete on successful write;
- update with authoritative write result;
- publish invalidation after commit;
- include source version in key/value;
- use generational namespace/version bump; or
- rely on TTL when bounded staleness is acceptable.

Prefer invalidating/deleting over trying to recompute every derived variant unless all variants are known. Ensure database commit and invalidation are ordered; use an outbox/change stream when lost invalidations exceed tolerance.

Handle races:

1. reader misses and loads old value;
2. writer commits new value and invalidates;
3. reader writes old value after invalidation.

Prevent with version checks, delete-after-write patterns carefully analyzed, leases, or authoritative conditional cache updates. Test concurrent sequences.

Broad invalidation can create a fleet-wide origin spike. Rate-limit and warm progressively.

## Stampede and Hot-Key Protection

Protect same-key misses with request coalescing/single-flight so one fill runs and waiters share the result. Bound waiter count and fill duration; propagate cancellation without canceling a useful shared fill incorrectly.

Other controls:

- jitter TTLs;
- refresh popular items before hard expiry;
- limit per-key and global fill concurrency;
- serve bounded stale values while one refreshes;
- prewarm only proven hot keys;
- shard/replicate hot entries when the cache service itself saturates; and
- negative-cache repeated misses/errors briefly.

Distributed locks need expiry, ownership tokens, and safe release; they do not guarantee the filler remains alive. Avoid lock duration assumptions that can let stale workers overwrite newer values.

## Negative Caching

Cache not-found, validation, or dependency failures only when their meaning and retry window are stable.

- Use shorter TTLs than positive data where creation/recovery may occur soon.
- Include authorization and tenant scope.
- Distinguish definitive absence from temporary timeout/overload.
- Never cache transient authentication or permission failure beyond safe policy freshness.
- Prevent attackers from filling vast negative-key space.

Negative caching can protect an unhealthy origin from repeated impossible requests, but can also delay recovery or leak existence through timing.

## Capacity and Eviction

Model working set, key/value overhead, replicas, allocator fragmentation, and burst growth. Choose eviction from access distribution and semantics: LRU, LFU, TTL-oriented, size-aware, or explicit no-eviction with admission control.

- Set maximum item and total memory limits.
- Observe eviction rate and which classes are displaced.
- Separate critical and opportunistic data when one can starve the other.
- Avoid unbounded per-user/query keys.
- Use admission policies to reject one-hit pollution.
- Test rebalancing and node loss; consistent hashing still moves keys.

Cache hit ratio can remain high while high-cost misses overload the origin. Measure weighted origin work.

## Failure Behavior

Define behavior for timeout, connection exhaustion, partial cluster, data loss, corrupt value, high eviction, and total cache outage.

Possible modes:

- bypass to origin with strict concurrency and rate limits;
- serve bounded stale data;
- reject low-priority work;
- degrade optional features; or
- fail closed for security/correctness-sensitive data.

Do not let every request synchronously fall through to an origin sized only for warm-cache traffic. Test disabled-cache load and retain enough origin capacity or admission control to recover.

Set short cache-operation deadlines and bounded pools. A cache intended to reduce latency must not become a slower hard dependency.

## Security and Privacy

- Authenticate cache clients and use least-privilege network/data access.
- Encrypt sensitive data and transport where required.
- Isolate environments, tenants, and trust zones.
- Prevent cache poisoning by validating data before insertion and scoping keys correctly.
- Avoid storing credentials, raw tokens, secrets, or highly sensitive content when possible.
- Restrict key enumeration, debug endpoints, snapshots, backups, and admin consoles.
- Clear identity-scoped cache state on logout/tenant switch when clients retain it.
- Consider timing and hit/miss side channels.

Never cache authorization decisions longer than the allowed revocation window. A deny can also be sensitive because it reveals resource existence or policy.

## Observability

Measure by cache, operation, tenant class, and key class without unbounded labels:

- hit, miss, stale hit, bypass, fill, negative hit, and error rates;
- hit and miss latency distributions;
- origin request rate/cost and fill amplification;
- item count, bytes, fragmentation, eviction, and expiration;
- coalesced waiters, lock contention, hot keys, and refill duration;
- invalidation delay/failure and age of served values; and
- cold-start, node-loss, and deployment behavior.

A ratio alone hides volume. Report counts and origin impact. Sample safe key fingerprints rather than raw sensitive keys.

## Testing and Rollout

Test:

- deterministic key generation and tenant/user isolation;
- schema-version and corrupt-value handling;
- TTL boundaries, clock behavior, stale policy, and negative entries;
- concurrent miss coalescing and update/fill races;
- invalidation after commit and lost/duplicate notifications;
- hot keys, skew, capacity, eviction, and key explosion;
- cold fleet, cache restart, node loss, timeout, and total outage;
- origin protection under miss storms; and
- data leakage and poisoning.

Roll out behind an observable control when risk warrants it. Compare correctness and latency against uncached results through safe sampling. Ramp traffic gradually, especially after cache version changes or flushes.

## Decision Output

```text
Cache decision:
- Problem, baseline, and expected reuse:
- Authority and correctness/staleness requirement:
- Placement and pattern:
- Key and value schema:
- TTL, invalidation, and race handling:
- Capacity, eviction, and stampede controls:
- Security and failure behavior:
- Measurements, tests, and rollout/disable plan:
```

Do not claim the cache improves availability or scale until cold, failed, and recovery modes demonstrate that the origin and service remain protected.
