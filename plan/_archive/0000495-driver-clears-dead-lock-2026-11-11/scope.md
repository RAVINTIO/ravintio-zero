---
title: "Scope - Driver clears a dead lock"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.106.0"
---
# Scope - Driver clears a dead lock

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000495-driver-clears-dead-lock
**Version:** 0.106.0

## In Scope

- The driver reads `plan/.initiative-runner.lock` when the `wx` write fails with `EEXIST`.
- The driver takes the lock if the file holds only a decimal pid and that process does not run. It prints one line that names the pid.
- The driver keeps the refusal for a live pid, a non-numeric lock, and a symlink.
- Tests for each outcome in `src/ravintio-zero/tests/`.
- The driver header comment and `roadmap-standards.md` state the rule.
- ADR-0324 records the decision. `docs/decisions-index.md` lists it.
- A refresh of `ravintio-zero/` with `sync-installed.mjs`.

## Out of Scope

- The `--handoff` path.
- `resume-detect.mjs`, the watcher, and the status script. They still report "driver lock held" for a dead lock.
- Any hook guard.
- Locks on other files.

## Deferred

Nothing deferred.
