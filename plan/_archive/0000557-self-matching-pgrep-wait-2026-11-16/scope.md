---
title: "Scope - Safe suite wait"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Safe suite wait

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000557-self-matching-pgrep-wait
**Version:** 0.133.0

## In Scope

- A wait rule in step 15 of the P0 start actions reference.
- A wait rule in the fast batch of `ravintio-validate-and-accept`.
- One test that checks both rules and bans a `pgrep -f` wait in skills and standards.
- A line in `docs/architecture-overview.md`.

## Out of Scope

- Scripts and hooks that wait on a process.

## Deferred

Nothing deferred.
