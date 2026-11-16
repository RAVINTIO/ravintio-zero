---
title: "Requirement: REQ-001 - Ledger rows with a true Detect line"
summary: "A suite pins the ledger skip rules of resume-detect.mjs when a Detect line is true."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Ledger rows with a true Detect line

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000560-step-sessions-and-pending-migrations
**Version:** 0.141.0
**Source:** US-001
**Priority:** must-have

## User Story

As a pack maintainer, I run a test that plants each ledger row kind beside a Detect match. A change to the skip rules then fails the suite.

## Functional Requirements
- A suite plants a `done` row beside a true Detect line and expects no pending line.
- The suite plants a `not applicable` row at the current pack version beside a true Detect line and expects the pending line.
- The suite plants a `not applicable` row at an older pack version beside a true Detect line and expects the pending line.
- The suite plants a `not applicable` row at the current pack version beside a false Detect line and expects no pending line.

## Acceptance Criteria
- [ ] AC-1: a done row stays quiet
  - Given a migration with a true Detect line and a `done` ledger row
  - When `resume-detect.mjs` runs
  - Then it prints no pending line for the migration
- [ ] AC-2: a not applicable row with a true Detect line reports
  - Given a migration with a true Detect line and a `not applicable` row at the current or an older pack version
  - When `resume-detect.mjs` runs
  - Then it prints the pending line for the migration
- [ ] AC-3: a not applicable row with a false Detect line stays quiet
  - Given a migration with a false Detect line and a `not applicable` row at the current pack version
  - When `resume-detect.mjs` runs
  - Then it prints no pending line for the migration

## Dependencies
- None
