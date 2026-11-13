---
title: "Requirement: REQ-003 - metrics by class and tier"
summary: "workflow-metrics.mjs reports units and rework by class and tier, so later runs can tune the table from evidence."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - metrics by class and tier

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000386-unit-dispatch
**Source:** US-003
**Priority:** should-have

## User Story

As a pipeline maintainer, I read rework by class and tier, so that I can tune the table from evidence.

## Functional Requirements
- `workflow-metrics.mjs` adds a `## Dispatch by class and tier` section after the governance table. It has one row per class and tier pair, with the unit count and the rework count.
- A `Rework: REQ-{nnn}:` marker counts toward the class and tier of the last classified `Done:` line before it that names that requirement. With none, it counts as `unclassified`.
- A `Done:` line without class fields counts as `unclassified`.
- The section reports and never blocks. The exit codes and the governance table stay as they are.
- `workflow-governance-standards.md` describes the section.

## Acceptance Criteria
- [ ] AC-1: units are counted by class and tier
  - Given a build log with three classified `Done:` lines
  - When `workflow-metrics.mjs` runs
  - Then the section lists each class and tier pair with its unit count
- [ ] AC-2: rework follows the unit
  - Given a `Rework: REQ-001:` marker after a `Done:` line for REQ-001 of class `code` and tier `primary`
  - When `workflow-metrics.mjs` runs
  - Then the `code` and `primary` row shows one rework
- [ ] AC-3: legacy logs still work
  - Given a build log whose `Done:` lines carry only a time
  - When `workflow-metrics.mjs` runs
  - Then it exits 0 and counts the lines as `unclassified`

## Dependencies
- none
