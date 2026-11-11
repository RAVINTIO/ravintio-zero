---
title: "Scope - Merge ready PRs after a stop"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Merge ready PRs after a stop

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000446-drain-ready-prs-after-a-stop
**Version:** 0.91.0

## In Scope

- The `schedule()` loop in `initiative-run.mjs` keeps queueing ready PRs after a queue failure, one attempt per step.
- Each failure prints its own `I-D Advance: Blocked:` line, and the failed step reports `stopped`.
- The roadmap standards state the drain rule.
- A test with two ready PRs and a queue that fails on one.

## Out of Scope

- A manual drain command for a stopped driver. A driver restart already queues each `ready` step.
- New step starts after a stop.
- Queue worktree cleanup after a failure (backlog 0000477).
- A change to `merge-queue.mjs`.

## Deferred

Nothing deferred.
