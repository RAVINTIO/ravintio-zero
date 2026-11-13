---
title: "Scope - Step sessions receive the clock"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.112.0"
---
# Scope - Step sessions receive the clock

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000534-step-sessions-receive-clock
**Version:** 0.112.0

## In Scope

- The flag `--include-hook-events` in `runStep` of `initiative-run.mjs`.
- The script `step-clock-check.mjs`.
- Tests with fixture logs in `src/ravintio-zero/tests/`, and the driver args helper.
- The driver header comment and the Step logs section of `roadmap-standards.md`.
- ADR-0342 records the decision and the proof. `docs/decisions-index.md` lists it.
- A refresh of `ravintio-zero/` with `sync-installed.mjs`.

## Out of Scope

- A time zone setting for step sessions.
- A change to the clock hook, the watcher, or any driver line.
- A test that starts a real `claude` session in CI.

## Deferred

Nothing deferred.
