---
title: "ADR 004: Structured P0 Discovery Pass and discovery.md Lifecycle"
summary: "Every adoption mode performs a structured discovery pass at the start of P0, writing findings to a new plan/current/discovery.md that follows build-log.md/design.md's fresh-each-run, archived-at-P7 lifecycle — a relocation of each mode's existing informal discovery behavior, not new scanning capability."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000017-ratchet-forgery-detection-and-telemetry-schema-spec"
---
# ADR-0078 - Structured P0 Discovery Pass and discovery.md Lifecycle

**Skill:** [adr-agent](../../../planifest-framework/skills/planifest-adr-agent/SKILL.md)
**Tool:** claude-code
**Model:** claude-sonnet-5
**Feature:** 0000017-ratchet-forgery-detection-and-telemetry-schema-spec
**Component:** planifest-framework
**Status:** accepted
**Date:** 2026-07-25

---

## Context

Today, each adoption mode's P0 start gathers a different amount of contextual information before coaching begins:
- Retrofit has a fully-specified 6-step scan.
- Standard Iterative informally "reads `plan/` before coaching".
- Greenfield does nothing beyond the shared Phase 0 Start Actions.
- External Anchor only reads `external-versioning.md`.

None of these write their findings to a dedicated artifact. Each either presents the findings inline in chat or folds them into `build-log.md`'s Q&A audit trail or `design.md`'s curated output. Both are the wrong home for raw findings.

This item started narrower, giving Retrofit's existing discovery step its own file. The scope broadened mid-session once the human observed that the reasoning applied equally to all four adoption modes, not only Retrofit.

---

## Decision

Every adoption mode performs a structured discovery pass at the start of P0, before coaching begins. It writes its findings to a new `plan/current/discovery.md`, separate from `build-log.md` and `design.md`. This is a relocation and structuring exercise, not new scanning capability. Each mode's content is what that mode's P0 already gathers today. That means Greenfield's baseline signals, Standard Iterative's `plan/`-history read, Retrofit's existing 6-step scan, and External Anchor's `external-versioning.md` read. Each mode now gets a common shared header (mode signal, git pre-flight, skills-inbox scan) and a dedicated file.

`discovery.md` follows the same fresh-each-run lifecycle as `build-log.md`/`design.md`: archived to `plan/_archive/{feature-id}-{date}/` at P7, recreated at the next P0. A partial discovery-pass failure states plainly, in the affected section, that it couldn't be determined, and coaching proceeds on the rest. It never blocks hard, consistent with the framework's existing fail-open-but-communicative convention. On resume within a still-in-progress pipeline run, the agent trusts the existing `discovery.md` as-is. It regenerates a missing or incomplete file fresh rather than patching it, since discovery is a read-only scan with no human dialogue to preserve.

---

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Leave discovery informal per-mode, no dedicated file (status quo) | No new artifact to maintain | Findings scattered across chat, `build-log.md`, or nowhere, depending on mode; no consistent place for a human to see what P0 already knows before being coached | Rejected — this was the exact gap that prompted the item |
| Fold discovery findings into `design.md` directly | One fewer file | Mixes raw findings with curated, human-confirmed decisions; `design.md` doesn't exist until after coaching, too late for findings meant to inform it | Rejected — wrong lifecycle stage |
| Dedicated `discovery.md`, fresh each run, archived at P7 (this decision) | Clean separation of raw findings from decisions and from the audit trail; enables a discovery commit to land before the design-confirmation commit; matches `build-log.md`/`design.md`'s existing lifecycle convention | One more artifact in `plan/current/` to keep synchronized | Chosen — smallest structural addition that fully closes the gap |

---

## Affected Components

| Component | Impact |
|-----------|--------|
| `planifest-orchestrator` skill | Adoption Modes section rewritten for all 4 modes to define and require a structured discovery pass |
| `design.template.md` | Reference updated to point to `discovery.md` instead of embedding findings |

---

## Consequences

**Positive:**
- Every pipeline run now has one place showing exactly what P0 already knew before asking the human anything
- Commits can separate "what we found" from "what we decided"
- Consistent behavior across all 4 adoption modes instead of 4 different informal conventions

**Negative:**
- Greenfield, Standard Iterative, and External Anchor modes gain a new formal step where previously they had an informal or nonexistent one. This adds slightly more process for the lightest adoption mode (Greenfield), where there is rarely anything interesting to discover

**Risks:**
- This item grew mid-session from a Retrofit-only file relocation to a 4-mode requirement (logged in `build-log.md`). The Greenfield/Standard Iterative/External Anchor sections relocate existing *informal* behavior and are not yet proven complete. If a mode's real P0 behavior includes steps outside req-006's specification, the discovery pass will silently omit them until corrected

---

## Related ADRs

- None directly. This is a new artifact type, not an extension of a prior discovery-related decision

---

## Supersedes

- None

## Superseded By

- None

---

*Generated by adr-agent.*
