---
title: "Scope - Pending migrations reach the human early"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Pending migrations reach the human early

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000536-pending-migrations-reach-the-human-early
**Version:** 0.113.0

## In Scope

- A `Chart-time migrations` section in the roadmap standards, and a pointer in the initiative skill.
- An I-C Run rule and a coordinator rule in the roadmap standards.
- A step-session rule under check 1 of the orchestrator resume-detection reference.
- One line in `ravintio-migrator` that lets a chart row stand in for the human's reply.
- A test, an ADR, and the living docs.

## Out of Scope

- Changes to `resume-detect.mjs` output.
- Changes to migrator behaviour in a human session.
- Any hook change.
- Charting a migration answer after the run starts.

## Deferred

Nothing deferred.
