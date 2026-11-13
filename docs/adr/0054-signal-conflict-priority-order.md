---
title: "ADR-0054: Signal Conflict Priority Order"
summary: "When multiple adoption mode signals are present, External Anchor takes absolute priority, followed by Standard Iterative, Retrofit, and Greenfield."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000014-improve-adoption-mode-selection"
---
# ADR-0054 - Signal Conflict Priority Order

**Skill:** planifest-adr-agent
**Tool:** Claude Code
**Model:** claude-sonnet-4-6
**Feature:** 0000014-improve-adoption-mode-selection
**Component:** planifest-framework
**Status:** accepted
**Date:** 2026-05-19

---

## Context

Filesystem signals detect four adoption modes, so a conflict is possible. A project could have both `docs/about.md` (Standard Iterative signal) and `planifest-overrides/instructions/external-versioning.md` (External Anchor signal) present at once. Without an explicit priority order, the orchestrator's mode recommendation would be undefined or would depend on file discovery order.

---

## Decision

**Priority order: External Anchor > Standard Iterative > Retrofit > Greenfield.**

- External Anchor is absolute: if `external-versioning.md` is present, this mode activates regardless of all other signals. It cannot be overridden by the human.
- Standard Iterative beats Retrofit. If `docs/about.md` is present and External Anchor is absent, the orchestrator selects Standard Iterative. It does so even if codebase files also exist (they always do for an ongoing project).
- Retrofit beats Greenfield: if codebase files exist and no `docs/about.md`, this is Retrofit.
- Greenfield is the default when no other signal is present.

External Anchor cannot be overridden because the override file (`external-versioning.md`) is a deliberate, explicit instruction that the user places in `planifest-overrides/`. Choosing it means the user has already made the decision. Allowing a human to override it in the coaching conversation would silently contradict their own configuration.

---

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Last-write wins (most recently modified signal file) | No need for a priority table | Non-deterministic; fragile to filesystem timestamps | Rejected — unreliable and hard to reason about |
| Human always chooses with no recommendation | Maximum human control | Requires human to understand what each mode means; no guidance | Rejected — defeats the purpose of detection |
| Standard Iterative beats External Anchor | `about.md` is more common, lower-friction | External Anchor represents an explicit override instruction; it should win | Rejected — contradicts the user's own configuration |
| Priority order with External Anchor overridable | Flexible | External Anchor exists precisely to enforce a constraint; making it overridable is contradictory | Rejected — design intent conflict |

---

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-orchestrator skill | Priority evaluation order implemented in mode detection |

---

## Consequences

**Positive:**
- Mode detection is deterministic and auditable. The same signals always produce the same mode
- External Anchor's priority reflects its intent as an override instruction

**Negative:**
- If a user has `external-versioning.md` and forgets it's there, they cannot override to Standard Iterative without deleting the file. This may feel surprising

**Risks:**
- A stale `external-versioning.md` left in `planifest-overrides/instructions/` from a past constraint that no longer applies will silently activate External Anchor mode. The orchestrator mitigates this by surfacing the file contents and asking the human to confirm before proceeding

---

## Related ADRs

- ADR-0053: depends-on (four modes must be defined before priority can be set)

---

## Supersedes

- None

## Superseded By

- None
