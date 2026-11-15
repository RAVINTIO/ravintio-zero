---
title: "Requirement: REQ-002 - Frozen lines and boot cap"
summary: "The Reference file edit cause names the frozen-line check and the boot template cap."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Frozen lines and boot cap

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000567-test-impact-size-caps-and-frozen-lines
**Version:** 0.125.0
**Source:** US-002
**Priority:** must-have

## User Story

As a plan author, I see the frozen-line check and the boot template cap named, so that I list them under `## Test impact`.

## Functional Requirements
- The `Reference file edit` cause names `test-0000151-req-011-orchestrator-references-split.sh`.
- The cause says the suite freezes every base line of the orchestrator skill.
- The cause says the suite caps the boot template, and to read the cap from the suite.

## Acceptance Criteria
- [ ] AC-1: suite named
  - Given the reference file
  - When a reader looks at the `Reference file edit` cause
  - Then it names `test-0000151-req-011-orchestrator-references-split.sh`
- [ ] AC-2: frozen lines and boot cap named
  - Given the cause
  - When a run edits an orchestrator reference file
  - Then the cause names the frozen base lines and the boot template cap
- [ ] AC-3: scan stays within its size
  - Given the plan scan and the reference file
  - When a reader counts the lines
  - Then the scan holds 20 lines or fewer

## Dependencies
- None
