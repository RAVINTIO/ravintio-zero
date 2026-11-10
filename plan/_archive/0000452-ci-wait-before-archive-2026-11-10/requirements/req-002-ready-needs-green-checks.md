---
title: "Requirement: REQ-002 - Ready needs green checks"
summary: "A step writes ready only when every check on the PR head passed."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-002 - Ready needs green checks

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000452-ci-wait-before-archive
**Source:** US-002
**Priority:** must-have

## User Story

As the merge queue, I receive `ready` only for a PR head whose checks all passed, so that I never merge an unchecked PR.

## Functional Requirements
- After the closing push, the step waits for the checks on the new head with `gh pr checks {n} --watch --fail-fast`.
- The step writes `ready` only when `gh pr checks {n}` exits 0 for that head.
- A pending check or a failed check means no `ready`. A failed check on the archive head prints `I-D Advance: Blocked:`.
- The ship skill and the roadmap standards state the rule.

## Acceptance Criteria
- [ ] AC-1: Refuses on pending or failed
  - Given a check that is pending or failed on the PR head
  - When a test reads the I-D Advance stage
  - Then the text forbids writing `ready` and names the `Blocked:` line
- [ ] AC-2: Waits on the archive head
  - Given the closing push
  - When a test reads the order of the stage
  - Then a second `gh pr checks` wait comes after the push and before `ready`
- [ ] AC-3: Ship skill states the rule
  - Given the ship skill text
  - When a test reads the initiative section
  - Then it says the step writes `ready` only after every check passed

## Dependencies
- ADR-0298
- REQ-001
