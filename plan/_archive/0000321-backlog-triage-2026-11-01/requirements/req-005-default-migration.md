---
title: "Requirement: REQ-005 - default migration"
summary: "Migration 0007 sets a default priority and theme on existing entries."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - default migration

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000321-backlog-triage
**Source:** US-005
**Priority:** must-have

## User Story

As a maintainer, I get a default priority and theme on existing entries, so that the index is complete on day one.

## Functional Requirements
- `ravintio-zero/migrations/0007-backlog-priority-and-theme.md` follows the shape of migration 0006, with `Applies when:` and `Detect:` lines.
- Helpers `migrate-backlog-priority-and-theme.sh` and `.ps1` add `priority: medium` and `theme: unsorted` to each entry that lacks the field. They add each field once, change nothing else, and skip a symlink.
- The helpers regenerate the index with `backlog-index.mjs`.
- This step applies the migration in this repo and records `0007 | done` in `plan/state/migrations.md`.

## Acceptance Criteria
- [ ] AC-1: helper adds missing fields
  - Given entries with no `priority` or `theme`
  - When the helper runs
  - Then each gains `priority: medium` and `theme: unsorted` and no other line changes
- [ ] AC-2: helper is idempotent
  - Given entries that already hold both fields
  - When the helper runs again
  - Then no file changes
- [ ] AC-3: this repo is migrated
  - Given this repo after the step
  - When a test reads each entry and the ledger
  - Then every entry holds both fields and the ledger holds a `0007` row

## Dependencies
REQ-002
