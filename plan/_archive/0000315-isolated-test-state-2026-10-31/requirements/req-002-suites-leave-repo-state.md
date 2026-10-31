---
title: "Requirement: REQ-002 - no suite writes repo state"
summary: "no suite writes repo state."
status: "active"
version: "0.41.2"
---
# Requirement: REQ-002 - no suite writes repo state

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000315-isolated-test-state
**Source:** US-002
**Priority:** must-have

## User Story

As a developer, I want the runner to fail when a run changes the tree, so that a test never leaves repo state behind.

## Functional Requirements

- Every suite that writes `.next-id`, `plan/`, or `.claude/` works on a temporary copy.
- P2 audits the suites by running the full suite under the REQ-003 check.

## Acceptance Criteria

- [ ] AC-1: a full run leaves the tree as found
  - Given a clean working tree
  - When the full suite runs
  - Then the REQ-003 check reports no changed path

## Dependencies

REQ-003
