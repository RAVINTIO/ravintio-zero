---
title: "Scope - Ship removal needs human approval"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Ship removal needs human approval

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000519-ship-removal-needs-human-approval
**Version:** 0.101.0

## In Scope

- Ship Step 4 item 4 in `ravintio-ship/SKILL.md`.
- Rule `implement-full-suite-once` and the fast batch docs line in `ravintio-implement/SKILL.md`.
- One pin suite, one ADR, docs, a changelog entry, and the sync to `ravintio-zero/` and `.claude/`.

## Out of Scope

- Guard or hook changes. No guard gains a new allowed form.
- Driver changes.
- Teaching the safety check to accept other removal commands.

## Deferred

Nothing deferred.
