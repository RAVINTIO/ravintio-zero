---
title: "Scope - Reply time matches the clock"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Reply time matches the clock

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000468-reply-time-matches-the-clock
**Version:** 0.83.0

## In Scope

- The clock comparison in `check-reply-prefix.mjs`, with a 5-minute margin and two override variables.
- The read-the-clock rule text in the roadmap standards, both skills, the boot templates, and the hook reference.
- Fixed clocks in the two 0000388 suites.
- ADR-0305, docs, and a changelog entry.
- The sync of `ravintio-zero/` and `.claude/` with `sync-installed.mjs` and setup.

## Out of Scope

- Blocking a turn. The hook warns and logs only.
- Changes to `check-design.mjs`.

## Deferred

Nothing deferred.
