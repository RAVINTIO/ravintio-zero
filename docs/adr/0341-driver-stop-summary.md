---
title: "ADR 0341: Driver prints a stop summary"
summary: "The driver ends every run with a summary block of merged steps, its own fixes, and the one action left for the human."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0341 - Driver prints a stop summary

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000511-driver-stop-summary
**Component:** ravintio-zero
**File:** `docs/adr/0341-driver-stop-summary.md`
**Date:** 2026-11-13

## Context

At each driver stop, the human reads many lines to learn what happened and whether they must act. The driver prints one state line per step, and the coordinator gathers the rest by hand. The stop at step 27 of initiative 0000360 showed the cost.

## Decision

`out()` in `initiative-run.mjs` records each merge line and each driver fix line. At every end of a run, the driver prints a summary block after its last other line. The block has these lines.

1. `I-C Run: Summary: merged this run: {steps or none}`
2. `I-C Run: Summary: driver fixes: {count}`, then one `I-C Run: Summary: fix: {line}` for each fix, up to 10
3. `I-C Run: Summary: action for the human: {action}`

The action is `none` after a clean end. A pending delivery, a `Restart:` stop, a `Setup:` stop, and every other stop each get their own action text. The summary changes no exit code and prints inside a `try` block.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Write a summary file | The coordinator reads it later | A second place to look, and a file to clean up | The watcher and the human already read stdout |
| Change the existing lines | No new lines | Readers of those lines break | The summary must not alter them |
| Leave it to the coordinator | No code | The coordinator gathers the lines by hand at each stop | It is the problem |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `initiative-run.mjs` gains the recorder and the printer. `roadmap-standards.md` states them. |

## Consequences

**Positive:**
- The human reads three kinds of line to learn the outcome and the action.
- The block lists the driver's fixes, so the coordinator need not collect them.

**Negative:**
- The driver output gains up to 13 lines at each end.

**Risks:**
- The recorder misses a fix that has no line. The full output still holds it.

## Related ADRs

- ADR-0340 - related-to: the `Cleared:` line is one of the driver fixes.
- ADR-0327 - related-to: the summary keeps the planned restart exit code.

## Supersedes

None.

## Superseded By

None.
