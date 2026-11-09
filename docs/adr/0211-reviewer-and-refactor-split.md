---
title: "ADR-0211 - A fresh reviewer proposes and the refactor skill applies"
status: "accepted"
component: "ravintio-zero"
feature: "0000202-improvement-loops"
---
# ADR-0211 - A fresh reviewer proposes and the refactor skill applies

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000202-improvement-loops
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

Backlog entry 0000179 asks for a fresh-context reviewer and an implementer that applies the changes worth making. The pack has no reviewer skill. A new skill changes setup, the manifest, and the skill count in several docs.

## Decision

Define the cycle steps and the reviewer brief in the `## Improvement loop` section of the dispatch standard. The implement skill holds a short pointer, because the skills text has a line budget of 1447 lines (test 0000031). The `ravintio-implement` skill dispatches the reviewer as an unnamed subagent on the primary tier. The refactor skill describes an improvement mode, which applies the finding. The reviewer edits nothing. Cap the loop at 2 cycles per requirement and write one `Improve:` marker per cycle.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| A new `ravintio-improvement-reviewer` skill | A named, reusable role | Setup, manifest, and skill counts all change | Too wide for one release. The brief is short. |
| Reuse ravintio-refactor for review and apply | No new text | The same context reviews and applies, so it is not independent | The entry asks for a fresh-context reviewer |
| A loop toggle in `loop-toggles.yml` | Opt-in rollout | Absent means off, so the wanted outcome fails by default | Out of scope |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | The implement and refactor skills |

## Consequences

**Positive:**
- The loop needs no new skill and no setup change.

**Negative:**
- The reviewer brief has no skill file of its own, so the brief lives in the dispatch standard.

**Risks:**
- The loop churns on a reviewer that always finds something. R-003 records this.

## Related ADRs

- ADR-0210

## Supersedes

None.

## Superseded By

None.
