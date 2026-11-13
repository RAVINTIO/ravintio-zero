---
title: "Scope - Driver prints a stop summary"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.111.0"
---
# Scope - Driver prints a stop summary

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000511-driver-stop-summary
**Version:** 0.111.0

## In Scope

- A recorder in `out()` of `initiative-run.mjs` for merges, driver fixes, and a pending delivery.
- A summary printer that runs at every end of a run, including the signal stop.
- The three `I-C Run: Summary:` line kinds.
- Tests for each outcome in `src/ravintio-zero/tests/`.
- The driver header comment and `roadmap-standards.md` state the rule.
- ADR-0341 records the decision. `docs/decisions-index.md` lists it.
- A refresh of `ravintio-zero/` with `sync-installed.mjs`.

## Out of Scope

- Any change to an existing driver line.
- A summary file on disk and any watcher change.
- A new stop condition.

## Deferred

Nothing deferred.
