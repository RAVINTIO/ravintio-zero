---
title: "Requirement: REQ-001 - Scan causes in a reference file"
summary: "The plan skill's Test impact scan reads its causes from a reference file."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Scan causes in a reference file

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000562-test-impact-scan-lists-the-mirrored-pack-tree
**Source:** US-001
**Priority:** must-have

## User Story

As a plan author, I read the Test impact scan causes from a reference file, so that the plan skill stays small.

## Functional Requirements
- `skills/ravintio-plan/references/test-impact-causes.md` holds every earlier cause.
- The scan section of `SKILL.md` keeps the intro and the `none found` rule, and names the file.
- A `## Pack Index` row in `SKILL.md` names the file.
- Both trees hold the same file.

## Acceptance Criteria
- [ ] AC-1: causes move
  - Given the plan skill
  - When a reader opens the reference file
  - Then it names every earlier cause, from Skill count to Fixture-pinned line
- [ ] AC-2: pointer
  - Given the scan section and the Pack Index
  - When a reader looks for the causes
  - Then both name `references/test-impact-causes.md`

## Dependencies
- None
