---
title: "Scope - Safe parallel commits"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Safe parallel commits

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000359-safe-parallel-commits
**Version:** 0.56.0

## In Scope

- A rule in the orchestrator skill: while a subagent of the step runs, the step session never runs `git stash`, `git checkout -- {path}`, `git reset`, or `git clean`.
- A rule in the implement skill: test a clean tree in a scratch clone, and log in the build log when the step waits for its subagents before a tree-wide git operation.
- In `agent-dispatch-standards.md` `## Fast batches`: the `git commit -m "{message}" -- {paths}` form and the `git commit --amend` ban.
- Tests for each rule.

## Out of Scope

- A hook that blocks these commands.
- Other subagent git rules.
- Rewriting archived build logs.

## Deferred

Nothing deferred.
