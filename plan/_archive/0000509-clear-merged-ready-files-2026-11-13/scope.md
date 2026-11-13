---
title: "Scope - Driver clears ready files of merged steps"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.110.0"
---
# Scope - Driver clears ready files of merged steps

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000509-clear-merged-ready-files
**Version:** 0.110.0

## In Scope

- A pass in `schedule()` of `initiative-run.mjs`. It runs once at driver start, after the driver reads the chart and the control folders.
- The pass removes the `ready` file of each merged step and prints a `Cleared:` line.
- The pass keeps the file when a live session runs or the removal fails, and prints a `Kept:` line.
- Tests for each outcome in `src/ravintio-zero/tests/`.
- The driver header comment and `roadmap-standards.md` state the rule.
- ADR-0340 records the decision. `docs/decisions-index.md` lists it.
- A refresh of `ravintio-zero/` with `sync-installed.mjs`.

## Out of Scope

- Control folders and files of unmerged steps.
- The `running` file, the `stopped` file, and the folder itself.
- Worktrees and branches.
- A pass after each merge, because the queue already deletes the control folder of the step it merges.
- Any hook guard.

## Deferred

Nothing deferred.
