---
title: "Scope - queue failure recovery"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - queue failure recovery

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000454-queue-failure-recovery
**Version:** 0.78.0

## In Scope

- The queue reverts a stale set-version commit before it merges the base on a rerun.
- The queue detaches its worktree after every run.
- A suite for the failure, base change, and restart path.
- The architecture overview, an ADR, the decisions index, and a changelog entry.

## Out of Scope

- The rerun-safety and version-mismatch tests. Entry 0000400 covers them in step 36.
- The driver's detach at the start of a queue run.
- A rewrite of pushed history, and any force-push.
- A clean-up of files that a failed run wrote but did not commit.

## Deferred

Nothing deferred.
