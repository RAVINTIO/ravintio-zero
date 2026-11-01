---
title: "Backlog Entry: 0000268 - a new chart rule migrates the active initiative"
summary: "A retrospective finding, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000268 - a new chart rule migrates the active initiative

**Source feature:** none (initiative 0000238 retrospective)
**Source phase:** none (I-E Delivery)
**Deferral source:** retrospective `plan/retrospectives/0000238-backlog-clearance-two-initiative-2026-10-29.md`
**Date filed:** 2026-10-29

---

## Problem

Step 14 (0000252) added two chart rules. Step confirmations now need a `Confirmation:` row in `## Decisions`, and P1 skips need a `## P1 skips` table. The active `initiative.md` recorded both approvals as notes, because chart ran before step 14.

Step 15 then stopped with "I-C Run: Blocked: step 15 has no P1 skip row marked yes" (`plan/.initiative-logs/step-15.attempt-1.log`). The coordinator converted the notes in commit `8d0703d` after the human approved it, and the driver restarted.

## Suggested Action

- When a step adds or changes a chart format, the same step updates the active `initiative.md` to the new format.
- If the step can't convert a record, it adds a backlog entry and names the record in its PR.

## Wanted outcome

No step stops on a chart format that a step earlier in the same initiative introduced. Tests check these conditions:

- The plan skill tells a step that changes a chart format to update the active `initiative.md`.
- A step that adds a chart table leaves the active `initiative.md` with that table.

## Why Deferred

The initiative retrospective found it at I-E Delivery. No step remained to take it.
