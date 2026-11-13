---
title: "ADR 001: product.yml Extended to Single-Component Projects as Declared Product ID Home"
summary: "product.yml's id field becomes the canonical declared product_id for telemetry across all projects, including single-component ones that previously had no product.yml at all — extending, not superseding, ADR-0068."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000024-declared-product-id-for-telemetry"
---
# ADR-0094 - product.yml Extended to Single-Component Projects as Declared Product ID Home

**Skill:** [adr-agent](../../../planifest-framework/skills/planifest-adr-agent/SKILL.md)
**Tool:** claude-code
**Model:** claude-sonnet-5
**Feature:** 0000024-declared-product-id-for-telemetry
**Component:** planifest-framework
**Status:** accepted
**Date:** 2026-08-03

---

## Context

req-001 requires telemetry to source its `product_id` from a durable, human-declared identifier instead of a machine-local filesystem path (`git rev-parse --show-toplevel`). The natural home is `product.yml`'s existing `id` field. But 0000016's ADR-002 (accepted, still in force) explicitly states `Projects with exactly one component need no product.yml — the existing component.yml path is the fallback, keeping this repo's own tagging unchanged`. Most Planifest-managed projects are single-component. Applying req-001 as designed would therefore leave the majority of adopters without a durable `product_id` home. That is the exact gap req-001 exists to close.

This ADR considered two options. The first stores `product_id` in `component.yml` instead, avoiding any change to ADR-002's boundary. The second extends `product.yml`'s role to cover single-component projects too, for this one purpose only. The human on the loop confirmed the second option during this feature's P0 discovery pass, after the conflict surfaced.

---

## Decision

`product.yml`'s `id` field is the canonical declared `product_id` for telemetry, for single-component projects as well as multi-component ones. This extends ADR-0068 rather than superseding it. ADR-002's core decision stays in force for multi-component projects exactly as before. That core decision covers the root `product.yml` schema, the `versionPolicy` enum, and ship-agent P9 ownership for version tagging. The single addition concerns single-component projects, which ADR-002 said need no `product.yml` for *versioning* purposes. They now get a minimal `product.yml` (containing only `id`, no `version`/`versionPolicy`/`components`) when telemetry needs a declared product identity. The orchestrator's P0 step 3b (req-001) creates it on first prompt, not ship-agent at P9. `component.yml`'s own versioning behaviour for single-component projects stays untouched. `product.yml`'s role for those projects covers strictly `id`, never version tagging.

---

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Store `product_id` in `component.yml`'s existing `id` field instead | No change to ADR-002's boundary; no new file for single-component projects | Conflates component identity with product identity — for a project that later grows to multiple components, `component.yml`'s `id` would need to stay stable as *a* component's id while a separate product id is introduced anyway, just delayed; also `component.yml` is per-component (`src/{component-id}/component.yml`), so there is no single canonical file to read for a single true product identity when multiple components exist even transiently | Confirmed by human: keeps product identity conceptually separate from component identity even when they coincide 1:1 today, avoiding a future migration when a project grows a second component |
| Do nothing — keep the git-path fallback for single-component projects, declared `product.yml` id only for multi-component | Zero new scope | Leaves the majority of adopters (single-component) with the exact machine-local-path problem req-001 exists to fix — defeats the requirement for most real usage | Rejected — contradicts req-001's stated goal |

---

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-framework | `product.yml` gains a defined minimal shape (`id`-only) for single-component projects; orchestrator P0 step 3b creates it on first prompt; 3 telemetry hooks read `id` from it regardless of project component count |

---

## Consequences

**Positive:**
- Every Planifest-managed project, single- or multi-component, gets a durable declared `product_id`. This closes req-001's gap for the majority (single-component) case, not only multi-component projects
- `component.yml`'s existing versioning behaviour for single-component projects provably stays the same. This ADR touches only the telemetry-identity concern, not tagging

**Negative:**
- A second root-level manifest (`product.yml`) now exists even for the simplest single-component project, where previously only `component.yml` existed. That is one more file for a human to notice and understand, even in its minimal `id`-only form

**Risks:**
- A future agent or human could see `product.yml` on a single-component project and mistakenly assume it also governs versioning there. It does govern versioning for multi-component projects. The minimal file mitigates this. It contains only `id`, with no `version`/`versionPolicy`/`components` fields to invite that assumption

---

## Related ADRs

- ADR-0068 (product.yml with versionPolicy) - extends: this ADR narrows and extends ADR-002's "single-component projects need no product.yml" statement for the telemetry-identity case specifically. ADR-002's versioning decision stays fully in force

---

## Supersedes

- None

## Superseded By

- None

---

*Generated by adr-agent.*
