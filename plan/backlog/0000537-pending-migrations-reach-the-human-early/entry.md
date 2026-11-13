---
title: "Backlog Entry: 0000537 - Pending migrations reach the human early"
summary: "On 2026-11-12 at 02:26 step 55 stopped in P0 to ask the human about pending migration 0009."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000537 - Pending migrations reach the human early

**Source feature:** 0000360-backlog-sweep
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-12
**Date filed:** 2026-11-12

---

## Problem

On 2026-11-12 at 02:26 step 55 stopped in P0 to ask the human about pending migration 0009. The driver exited, and the run waited about 4.5 hours for an answer. Steps 43 and 45 had reported the same migration as pending on 2026-11-11, and the coordinator never raised it with the human. The chart had no `## Decisions` row for pending migrations.

Evidence: `plan/.initiative-logs/step-55.log`, 02:26 on 2026-11-12.

## Suggested Action

The human set two rules on 2026-11-12.

At chart time:

- The initiative skill runs resume detection at I-A Chart and lists every pending migration.
- The human answers each one before any step starts.
- The coordinator records each answer as a `## Decisions` row, and a step applies that row instead of asking.

During steps:

- A step never stops on a pending migration. It records the migration in its build log and carries on.
- The coordinator raises the migration with the human the next time the human is available.
- A migration with a pre-approved `## Decisions` row runs at once, with no question.

## Why Deferred

Found at the step 55 stop of initiative 0000360. The human asked for a backlog entry, then made it step 61.
