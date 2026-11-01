---
title: "Backlog Entry: 0000334 - a step session that ends its turn early stops the driver"
summary: "A coordinator-observed defect, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000334 - a step session that ends its turn early stops the driver

**Source feature:** none (initiative 0000312 supervision)
**Source phase:** none (initiative 0000312 supervision)
**Deferral source:** human request
**Date filed:** 2026-11-01

---

## Problem

Step 7 of initiative 0000312 (feature 0000319) stopped after P2. The driver then printed `I-C Run: Blocked: step 7 is not merged into the initiative branch, position stayed at 7` and exited 1.

The step session wrote `P2 Implement: Complete: ... Next is P3 Validate.` and ended its turn. `claude -p` exits when the model ends its turn and no background task is pending. The driver sends one prompt, `Run initiative step {n}`, and never sends another. The process exited with `success`, so no `Blocked:` line explained the stop.

No text in the pack tells a step session to keep going. The orchestrator skill, the phase skills, and `ravintio-zero/standards/roadmap-standards.md` never say that a step session must not end its turn before `I-D Advance: Complete:` or a `Blocked:` line. The `Complete:` reply status reads like a hand-back to a human.

Earlier steps finished by chance:

- Step 5 ran from P0 to I-D Advance in one 95-turn reply.
- Step 6 ended its turn several times. Each time, a pending background suite run or CI wait sent a notification that woke it.
- Step 7 had nothing pending after P2, so nothing woke it.

The log is at `plan/.initiative-logs/step-7.log` in the coordinator's working tree.

## Suggested Action

Two fixes could work together:

| Fix | Where | Effect |
|-----|-------|--------|
| A rule that a step session never ends its turn before `I-D Advance: Complete:` or a `Blocked:` line | Orchestrator skill and the driver prompt in `ravintio-zero/scripts/initiative-run.mjs` | Prevents most early exits. It relies on the model following the rule. |
| If a step exits 0 unmerged with no `Blocked:` line, the driver resumes the session once with `claude -p --resume {session}` | `ravintio-zero/scripts/initiative-run.mjs` | Recovers with no human. It needs a cap so it can't loop. |

Neither fix widens a guard.

## Why Deferred

The driver for initiative 0000312 runs from the installed copy, and step 7 owns the working tree. The fix changes the driver and the orchestrator skill, so it needs its own step or feature.
