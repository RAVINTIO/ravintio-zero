---
title: "ADR 001: product.yml components[] as Path Pointers, Not Cached Versions"
summary: "Under versionPolicy max-component-version, product.yml's components[] now stores {id, path} pointers to each component's own component.yml, read live by product-version.mjs at derivation time, instead of a cached {id, version} copy that could drift out of sync."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000026-context-hook-and-telemetry-backstop-fixes"
---
# ADR-0098 - product.yml components[] as Path Pointers, Not Cached Versions

**Skill:** [adr-agent](../../../../planifest-framework/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000026-context-hook-and-telemetry-backstop-fixes
**Component:** planifest-framework
**Date:** 2026-08-08

## Context

ADR-0068 introduced `product.yml` to aggregate one release version across a project's components. Under `versionPolicy: max-component-version`, `components[]` held a cached `{id, version}` per component. That cache went stale the moment a component's own `component.yml` bumped its version outside a P9 ship. `context-mode-hooks` bumped 0.2.0 → 0.2.1 mid-PC during this feature's own 0000042 fix. `product.yml` never got the update. The gap surfaced only when this feature reached its own ship-review version-bump question. ADR-002's own alternatives analysis weighed "each component.yml claims the product version" (rejected: no single owner). It also weighed "always derive max, no manifest" (rejected: no support for `explicit`/`external` policies). It never considered a third option that keeps single ownership without a cached copy.

## Decision

Under `versionPolicy: max-component-version`, `components[]` entries hold `{id, path}` instead of `{id, version}`. The path points to that component's own `component.yml`. `product-version.mjs` reads each referenced `component.yml`'s live `version:` field at derivation time and takes the highest. `components[]` needs editing only when a component joins or leaves, never on a version bump. The `explicit` and `external` policies do not change. They never read `components[]` for version derivation. `product.yml`'s own top-level `version` field remains informational under `max-component-version` (the last value ship-agent tagged). It stays authoritative only under `explicit`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep cached `{id, version}`, add a P0/P9 consistency check that fails loudly on drift | No shape change; smaller diff | Still requires remembering to sync on every component version bump; a check only catches drift after it happens, doesn't prevent it | Treats the symptom, not the cause — the cache itself is the defect |
| Drop `product.yml`'s `components[]` entirely; have `product-version.mjs` glob for all `component.yml` files under the project root | No explicit list to maintain at all | No way to scope which components count toward the product version (a project could have `component.yml` files that are examples, templates, or intentionally excluded); loses the explicit single-owner list ADR-002 established | Removes a real capability (deliberate component inclusion) to save a few lines in `product.yml` |
| Keep `{id, version}` but require ship-agent to `grep` and sync it as a mandatory, checked P9 sub-step | No shape change | Exactly the manual-sync process that already existed and already failed once during this feature's own run | Doesn't fix the mechanism, just adds process on top of a mechanism proven to be missed |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-framework | `product.template.yml`, `product-version.mjs`, `planifest-ship-agent/SKILL.md` Step 9, `test-0000016-pipeline-governance.sh` (+ promoted regression copy) updated; new migration `planifest-framework/migrations/migrate-product-yml-component-paths.md` for adopter projects with an existing old-shape `product.yml` |

## Consequences

**Positive:**
- Eliminates the class of defect that prompted this ADR. Nothing in `product.yml` can go stale relative to a component's own version, because the file caches nothing
- `components[]` maintenance burden drops to exactly when it should change: component added or removed

**Negative:**
- `product-version.mjs` now does file I/O per component (reads each referenced `component.yml`) instead of pure string parsing of one file. The cost is negligible at this scale (single-digit components) and noted for completeness
- Existing adopter projects with an old-shape `product.yml` hit a hard failure (exit 2) at their next P9 tag under `max-component-version`. The failure lasts until they run the new migration. The breakage is not silent, but it blocks

**Risks:**
- A `components[]` entry with a `path` pointing at a moved, renamed, or deleted `component.yml` fails loudly (exit 2, named path in the error). The failure is loud, not silent. Treat that as a positive (fail loud, not stale-silent). It is also a new failure mode that did not exist before

## Related ADRs

- ADR-0068 - amends (this ADR is the amendment, see that ADR's own "Superseded By" note)

## Supersedes

- None (amends ADR-0068's `components[]` shape specifically. The rest of ADR-002 keeps its form: the `product.yml` file's existence, `versionPolicy` enum, and single-ownership model)

## Superseded By

- None
