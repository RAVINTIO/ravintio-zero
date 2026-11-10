---
title: "Scope - Driver reads blocks from the reply"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Driver reads blocks from the reply

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000440-driver-reads-reply-blocks
**Version:** 0.78.0

## In Scope

- Read the final `result` text of each session in `ravintio-zero/scripts/initiative-run.mjs`.
- Accept an `hh:mm` time and a short prefix before `Blocked:`.
- Name the archived build log, or none, in the continue prompt.
- Update the roadmap standards to match.

## Out of Scope

- The merge queue, the watcher, and the ready-file helper.
- The meaning of a `Resolved:` line.

## Deferred

Nothing deferred.
