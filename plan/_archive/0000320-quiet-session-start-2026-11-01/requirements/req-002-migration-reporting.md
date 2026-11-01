---
title: "Requirement: REQ-002 - migration reporting"
summary: "resume-detect reports a migration only while it needs action."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - migration reporting

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000320-quiet-session-start
**Source:** US-002
**Priority:** must-have

## User Story

As a developer, I see a migration finding only while it needs action, so that a repeated finding does not train me to ignore findings.

## Functional Requirements
- `resume-detect.mjs` reads `plan/state/migrations.md`. A row holds the migration id, a result (`done` or `not applicable`), and the pack version.
- A migration with a `done` row gives no finding.
- A migration with a `not applicable` row at the current pack version gives no finding, unless its `**Detect:**` condition is true.
- Any other pending migration gives `pending migration: {id}`, as today.
- A migration file may hold a `**Detect:**` line of items joined by ` | `. Each item is `exists {path}`, `contains {path} {text}`, or `child-exists {dir} {name}`. Paths are relative to the project root. Any true item makes the condition true.
- The script stays read-only, prints no repo text, and exits 0.
- A missing or unreadable ledger gives today's output.
- The pack version comes from `ravintio-zero/component.yml`.

## Acceptance Criteria
- [ ] AC-1: inapplicable migration is quiet at the same version
  - Given a `not applicable` row at the current pack version and a false `Detect:` condition
  - When `resume-detect.mjs` runs
  - Then it prints no finding for that migration
- [ ] AC-2: a pack update brings it back once
  - Given the same row and a newer pack version
  - When `resume-detect.mjs` runs
  - Then it prints `pending migration: {id}`
- [ ] AC-3: a true condition reports at once
  - Given the same row at the current version and a true `Detect:` condition
  - When `resume-detect.mjs` runs
  - Then it prints `pending migration: {id}`

## Dependencies
- REQ-003 writes the ledger. ADR-001 fixes its format.
