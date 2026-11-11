---
title: "Scope - Driver keeps uncommitted entries from a worktree"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.106.0"
---
# Scope - Driver keeps uncommitted entries from a worktree

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000497-keep-worktree-entries
**Version:** 0.106.0

## In Scope

- `removeWorktree()` lists untracked files under `plan/backlog/` in the step worktree before it removes the worktree.
- The driver keeps the worktree and stops the queue when it lists a file or when git fails.
- The ship skill tells a step to commit each backlog entry it filed, by explicit path.
- Tests for each outcome in `src/ravintio-zero/tests/`, with one new mode in the scheduler fixture.
- The driver header comment and `roadmap-standards.md` state the rule.
- ADR-0325 records the decision. `docs/decisions-index.md` lists it.
- A refresh of `ravintio-zero/` with `sync-installed.mjs`.

## Out of Scope

- Moving entries to the main tree's queue.
- Untracked files outside `plan/backlog/`.
- Removal of merged worktrees that nobody removes (step 52).
- Any hook guard.

## Deferred

Nothing deferred.
