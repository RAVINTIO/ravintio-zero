---
title: "ADR 312: Renumber colliding ids in the merge queue"
summary: "After the base merge, the queue gives a PR's ADR or backlog entry the next free id when the base holds the same id, and commits the change."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000485-adr-number-collision"
---
# ADR-0312 - Renumber colliding ids in the merge queue

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000485-adr-number-collision
**Component:** ravintio-zero
**File:** `docs/adr/0312-renumber-colliding-ids-in-the-merge-queue.md`
**Date:** 2026-11-11

## Context

Steps that run at once each reserve an ADR number from `docs/adr/.next-id` on their own branch. Steps 32, 33, and 35 of initiative 0000360 all took 0301. Two backlog entries took 0000479 the same way. The files have different slugs, so git reports no conflict on them. ADR-0302 lets the queue resolve the counter and the index rows, but nothing detects two files with one number.

## Decision

Add `id-collisions.mjs`. After the base merge, in the clean path and after `resolveSharedConflicts`, `merge-queue.mjs` calls it. The module compares the files that the PR added since the merge base with the files in the merged tree. For each ADR number or backlog id that another file also holds, it gives the PR's file the next free id. It renames the file, rewrites the heading, the index row, and the references in files the PR changed, and raises the counter. The queue commits the result, prints a `renumbered:` line for each change, and carries on to the CI wait.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Reserve numbers from one shared counter on `origin` | No collision at all | Needs a network call and a lock on every reservation | A step worktree must work offline and `reserve-id.mjs` stays local |
| Stop the queue and ask for a hand renumber | No rewrite risk | Costs a step session per collision | The case repeated in initiative 0000360 |
| Charts reserve ADR numbers per step | Numbers are unique by plan | Steps need decisions the chart cannot predict | A step may write zero or several ADRs |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Gains `id-collisions.mjs` and a queue call |

## Consequences

**Positive:**
- A merge with a colliding ADR or entry needs no hand edit.
- Every ADR and entry keeps a unique id.

**Negative:**
- A step's PR text may cite its old number until the queue renumbers it, and the queue rewrites only files the PR changed.
- The queue adds one commit when a collision exists.

**Risks:**
- A reference to the old number in an unchanged file goes stale. The `renumbered:` line names the change so a reviewer can look.

## Related ADRs

- ADR-0302 - extends

## Supersedes

None.

## Superseded By

None.
