---
title: "ADR 0340: Driver clears ready files of merged steps"
summary: "At start, the driver removes the ready file of each merged step unless a live session runs there. It keeps and reports every file it cannot clear."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0340 - Driver clears ready files of merged steps

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000509-clear-merged-ready-files
**Component:** ravintio-zero
**File:** `docs/adr/0340-driver-clears-merged-ready-files.md`
**Date:** 2026-11-13

## Context

The queue deletes the control folder of a step after it merges the step. If a step merged by hand or under an earlier driver, it keeps its `ready` file in `plan/.initiative-control/`. On 2026-11-11 the coordinator removed 7 of these files by hand, for steps 10, 11, 13, 16, 18, 20, and 34.

## Decision

`schedule()` in `initiative-run.mjs` clears once at start. It runs after the driver reads the chart and the control folders, and it skips a driver that takes over with `--handoff`. For each step with status `merged` and a `ready` file, it checks two things.

1. The `running` file of the step names no live pid.
2. The control path holds no symlink, and the removal succeeds.

If both hold, the driver removes the `ready` file and prints `I-C Run: Cleared: step {n} ready file of a merged step`. Otherwise it keeps the file and prints `I-C Run: Kept: step {n} {reason}`. The run goes on in both cases. The pass removes no other file and never removes the folder.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Delete the whole control folder | One removal covers every file | It also deletes a `stopped` or `running` file the coordinator may need | The request names the `ready` file only |
| Clear after each merge | Files never pile up | The queue already deletes the folder of the step it merges. The old files stay. | It does not reach the old files |
| Clear by hand | No code | The coordinator repeats it on each run | It is the problem |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `initiative-run.mjs` gains the pass. `roadmap-standards.md` states it. |

## Consequences

**Positive:**
- The coordinator no longer clears `ready` files by hand.
- The driver names each file that it keeps and says why.

**Negative:**
- A kept file prints a line on every driver start until the coordinator clears it.

**Risks:**
- A tool that reads `ready` for a merged step finds none. The chart already records the merge, so nothing in the pack reads it.

## Related ADRs

- ADR-0326 - related-to: the pass follows the shape of the worktree sweep.

## Supersedes

None.

## Superseded By

None.
