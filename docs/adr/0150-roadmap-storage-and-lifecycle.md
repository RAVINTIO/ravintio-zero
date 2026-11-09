---
title: "ADR 002: Roadmap storage and lifecycle"
summary: "Draft roadmaps live in plan/roadmap/ on any branch. The one active roadmap lives in plan/current-roadmap/ on the roadmap branch. Ids share the backlog sequence. The planifest-zero component owns both folders."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000043-autonomous-roadmaps"
---
# ADR-0150 - Roadmap storage and lifecycle

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Component:** planifest-zero
**Date:** 2026-10-23

## Context

Work that spans several features has no home in `plan/`. The backlog holds single entries and the human sequences them by hand. The human wants a roadmap to hold an ordered chain of steps, where each step is one feature built from one or more backlog entries.

The backlog already solves filing. A human or agent files an entry on any branch, and the entry reaches `main` through the normal PR. Pickup offers pull-in, leave, or discard, and a malformed entry is flagged. The human asked that roadmap drafts follow the same model. They also ruled out a chore PR to land a draft (build log, "chart approval").

An active roadmap needs more than a draft. It needs a branch, a status, a `position`, and a step table that changes with every merged step. Each step then runs as a normal feature in `plan/current/`.

## Decision

**Drafts.** A draft roadmap lives in `plan/roadmap/{id}-{slug}/roadmap.md`. A human or agent files it on any branch and in any phase, as with a backlog entry. Filing has no prefix. Chart picks it up with pull-in, leave, or discard, and flags a malformed draft.

**Active roadmap.** The active roadmap lives in `plan/current-roadmap/roadmap.md` on the roadmap branch `roadmap/{id}-{slug}`. R-B Activate writes it with `status: active` and deletes the draft folder in the same commit.

**Ids.** Roadmap ids share the backlog's seven-digit sequence. A roadmap id is never reused by a backlog entry or a feature.

**One active roadmap.** A working tree holds at most one folder in `plan/current-roadmap/`. R-B Activate refuses to start if one exists or if `roadmap/{id}-*` exists on `origin`.

**Data ownership.** The `planifest-zero` component owns `plan/roadmap/` and `plan/current-roadmap/`. The R-stages write to them. No other component writes there.

**Lifecycle.** Five stages, each with a message prefix:

| Stage | Prefix | Where |
|-------|--------|-------|
| Chart | `R-A Chart:` | `main` |
| Activate | `R-B Activate:` | roadmap branch |
| Run | `R-C Run:` | feature branch |
| Advance | `R-D Advance:` | roadmap branch |
| Delivery | `R-E Delivery:` | roadmap branch |

At R-E Delivery, `plan/current-roadmap/` moves to `plan/_archive/{id}-{slug}-roadmap-{date}/`. Session start checks `plan/current-roadmap/` before `plan/current/`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Land each draft through a chore PR | A reviewed draft before it exists on `main` | A PR for each idea. A draft cannot be filed mid-feature | The human rejected it. A roadmap is added on any branch, like a backlog entry |
| A separate roadmap id sequence | Roadmaps are visually distinct from features | Two counters to keep in step. Ids can collide in branch and tag names | Shared ids keep one counter and one lookup rule |
| Multiple active roadmaps in one working tree | Parallel chains | Resume detection, the driver lock, and `plan/current/` all assume one chain | Out of scope. The lock file and session start check need one active roadmap |
| Keep the active roadmap in `plan/roadmap/` | One folder | A draft and an active roadmap look the same. The driver cannot tell which to run | A separate folder makes the state visible from the path |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | Owns `plan/roadmap/` and `plan/current-roadmap/`. Gains `roadmap-entry.template.md`, the orchestrator stages, and resume detection changes |

## Consequences

**Positive:**
- A human files a long-term plan mid-feature without a PR or a branch switch.
- Backlog rules apply to drafts, so no new filing rules need learning.
- The path shows whether a roadmap is a draft or active.

**Negative:**
- Drafts on unmerged branches are invisible to Chart until they reach `main`.
- The shared id sequence means a roadmap uses an id that a feature cannot take.
- Only one chain can run at a time in a working tree.

**Risks:**
- A draft and an active roadmap could share an id if Activate fails after the push. The `origin` branch check and the same-commit delete reduce this risk.

## Related ADRs

- ADR-0149 - depends-on (Markdown files only, no new runtime)
- ADR-0151 - related-to (the merge path into the roadmap branch)
- ADR-0152 - related-to (the driver reads `plan/current-roadmap/roadmap.md`)
- ADR-0154 - related-to (stage prefixes and self-confirmed steps)

## Supersedes

- None

## Superseded By

- None
