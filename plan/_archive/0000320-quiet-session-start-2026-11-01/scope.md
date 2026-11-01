---
title: "Scope - Quiet session start"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Quiet session start

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000320-quiet-session-start
**Version:** 0.46.0

## In Scope

- Once-per-session load instruction in `auto-trigger-orchestrator.mjs` and the advisory banner of `check-orchestrator-presence.mjs`.
- Ledger-aware migration findings in `resume-detect.mjs`, with `Detect:` conditions.
- The migrator skill writing `plan/state/migrations.md`. Migration 0006 and its helpers. `Detect:` lines on 0004 and 0005.
- Final-reply check in `check-reply-prefix.mjs`.
- Tests, docs, version 0.46.0, and the changelog.

## Out of Scope

- The pack-version check (entry 0000272).
- Any hook that blocks.
- See other no-action findings (gap: out of scope).

## Deferred

Nothing deferred.
