---
title: "Scope - Pack prose to the standard"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Pack prose to the standard

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000395-pack-prose-to-the-standard
**Wave:** 1
**Version:** 0.75.0

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- Prose in Markdown under `ravintio-zero/`, `docs/` including the ADRs, `ravintio-overrides/`, and the repository root.
- The matching entries in `plan/state/prose-baseline.json`.
- Test pins on rewritten wording.

## Out of Scope

- Code, SQL, and data values.
- `plan/_archive/`, `ravintio-zero/tests/`, `CLAUDE.md`, and `AGENTS.md`.
- Plan history records under `plan/changelog/`, `plan/retrospectives/`, `plan/postmortems/`, and `plan/backlog/`.
- Changes to the linter rules.

## Deferred

Nothing deferred.
