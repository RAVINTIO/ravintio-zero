---
title: "Requirement: REQ-004 - Audit refresh at plan"
summary: "Audit refresh at plan"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Audit refresh at plan

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000387-light-discovery-and-audits
**Source:** US-004
**Priority:** must-have

## User Story

As a maintainer, I want the plan phase to re-run the dependency audit, so that a late advisory stops at the plan gate.

## Functional Requirements

- `ravintio-plan` re-runs the dependency audit before the plan gate when a requirement targets advisories or dependency versions.
- The build log gains `Audit: re-run at P1 ({result})`. The build log template documents the line.
- A fix outside the `Approved dependencies` list stops at the plan gate with the dependency exception stop.

## Acceptance Criteria

- [ ] AC-1: Re-run
  - Given a requirement that targets advisories
  - When the plan skill reaches the gate section
  - Then it re-runs the audit first
- [ ] AC-2: Log line
  - Given a re-run
  - When the plan skill logs it
  - Then the build log holds the Audit line and the template documents it
- [ ] AC-3: Stop
  - Given a fix outside the approved list
  - When the audit result is read
  - Then the plan gate stops with the dependency exception stop

## Dependencies

- None.
