---
title: "Requirement: REQ-001 - Skill-wide grep pin"
summary: "The test impact scan says to list suites that loop over every SKILL.md when a run adds a term to one."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Skill-wide grep pin

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000571-scan-cause-skill-wide-grep-pins
**Version:** 0.135.0
**Source:** US-001
**Priority:** must-have

## User Story

As a plan author, I list the suites that grep every skill. I do this when I add a term to a `SKILL.md`. No skill-wide pin then fails the full suite late.

## Functional Requirements
- The `Skill-text budget` cause in `skills/ravintio-plan/references/test-impact-causes.md` covers a run that adds a file name, command, or flag to a `SKILL.md`.
- The cause says to grep `ravintio-zero/tests/` for suites that loop over every skill and match the added term.
- The cause names `test-0000151-req-008-quiet-test-output.sh` as the example and says to list each match in the execution plan.
- The sentence extends the existing cause line and adds no line.

## Acceptance Criteria
- [ ] AC-1: the cause holds the skill-wide pin sentence
  - Given the `Skill-text budget` cause of the reference file
  - When a test reads the cause
  - Then it names every skill, the added term, `test-0000151-req-008-quiet-test-output.sh`, and says to list each match
- [ ] AC-2: the scan stays small
  - Given the scan text of the plan skill and its reference
  - When a test counts it
  - Then the text holds 21 lines or fewer
- [ ] AC-3: both trees match
  - Given the two pack trees
  - When a reader compares the reference file
  - Then the files are identical

## Dependencies
- None
