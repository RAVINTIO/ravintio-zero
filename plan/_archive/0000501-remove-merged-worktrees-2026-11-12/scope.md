---
title: "Scope - Driver removes merged step worktrees"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.107.0"
---
# Scope - Driver removes merged step worktrees

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000501-remove-merged-worktrees
**Version:** 0.107.0

## In Scope

- A sweep in `schedule()` of `initiative-run.mjs`. It runs once at driver start, after the driver reads the chart and the control folders.
- The sweep removes the worktree of each merged step when it is safe.
- The sweep keeps a worktree that has uncommitted files, a head off its origin branch, a live session, or a git error. It prints one `I-C Run: Kept:` line for each.
- Tests for each outcome in `src/ravintio-zero/tests/`.
- The driver header comment and `roadmap-standards.md` state the rule.
- ADR-0326 records the decision. `docs/decisions-index.md` lists it.
- A refresh of `ravintio-zero/` with `sync-installed.mjs`.

## Out of Scope

- Worktrees of unmerged steps.
- Deleting local or remote branches.
- The queue worktree and the control folders.
- A sweep after each merge, because the queue already removes the worktree of the step it merges.
- Any hook guard.

## Deferred

Nothing deferred.
