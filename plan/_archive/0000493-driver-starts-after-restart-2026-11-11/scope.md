---
title: "Scope - Driver keeps starting steps after a Restart"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Driver keeps starting steps after a Restart

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000493-driver-starts-after-restart
**Version:** 0.105.0

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- A handoff in the concurrent driver on a `Restart:`-only hit.
- A `--handoff` flag that makes a new driver adopt the lock and the running steps.
- A `stopped` file in the step control folder that carries a stop from the old driver.
- Updates to `roadmap-standards.md`, the driver header, the initiative skill, and the tests.
- One ADR, the living docs, and the changelog entry.

## Out of Scope

- The serial driver path, which holds no running steps.
- A `Setup:` or `Restart: Setup:` hit, which keeps the current stop.
- Clearing a dead lock (step 49) and the restart exit code (step 53).
- Removing merged worktrees (step 52) and keeping uncommitted entries (step 50).
- Changes to the watcher script, unless the lock pid change needs one.

## Deferred

- Nothing deferred.
