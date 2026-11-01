---
title: "Requirement: REQ-003 - migration ledger"
summary: "The migrator records migration state outside the pack."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - migration ledger

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000320-quiet-session-start
**Source:** US-002
**Priority:** must-have

## User Story

As a developer, I keep finished migrations outside the pack, so that a pack update does not bring one back.

## Functional Requirements
- The `ravintio-migrator` skill appends a row to `plan/state/migrations.md` when a migration finishes or is skipped as not applicable. It no longer moves files into `ravintio-zero/migrations/_done/`.
- The migrator edits nothing inside `ravintio-zero/`.
- Migration `0006-migration-ledger.md` and a helper script copy each `_done/` file of the pack into the ledger as a `done` row. The helper deletes nothing.
- Migrations 0004 and 0005 gain a `**Detect:**` line.
- This step applies migration 0006 in this repo and records 0004 and 0005 as `not applicable`.
- The helper keeps a `sh` and a `ps1` form, as the other migrations do.

## Acceptance Criteria
- [ ] AC-1: done row stays quiet after a pack update
  - Given a ledger `done` row for a migration and a pack that ships that migration as pending
  - When `resume-detect.mjs` runs
  - Then it prints no finding for it
- [ ] AC-2: a migrator run leaves the pack unchanged
  - Given a pending migration
  - When the migrator skill finishes it
  - Then the ledger holds a new row and `ravintio-zero/` has no change
- [ ] AC-3: migration 0006 copies old records
  - Given `ravintio-zero/migrations/_done/` holds migration files
  - When the 0006 helper runs
  - Then the ledger holds one `done` row for each, and rerunning adds no duplicate

## Dependencies
- ADR-001 for the ledger format.
