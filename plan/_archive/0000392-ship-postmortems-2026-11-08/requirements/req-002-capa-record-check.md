---
title: "Requirement: req-002 - CAPA record check"
summary: "CAPA record check."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - CAPA record check

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000392-ship-postmortems
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I see a postmortem fail when it lacks a corrective, preventive, or detective row, so that no record skips an action type.

## Functional Requirements

- `postmortem-check.mjs {record}` reads the Actions table of a record.
- The table has one row for each of `corrective`, `preventive`, and `detective`.
- A row either names an action with a status of `filed` or `done`, or reads `none, because {reason}`.
- A `done` row names its commit or PR in the `Ref` column.
- The template and the skill describe the table, and the skill runs the check before it commits.

## Acceptance Criteria

- [ ] AC-1: Missing type fails
  - Given a record with no `preventive` row
  - When the check runs on it
  - Then the check exits 1 and names `preventive`
- [ ] AC-2: None row passes
  - Given a record whose `detective` row reads `none, because {reason}`
  - When the check runs on it
  - Then the check reports no finding for `detective`
- [ ] AC-3: Done row needs a reference
  - Given a `done` row with an empty `Ref` cell
  - When the check runs on it
  - Then the check exits 1 and names the row

## Dependencies

- None
