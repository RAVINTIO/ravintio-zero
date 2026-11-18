---
title: "Requirement: REQ-002 - Planted-change test"
summary: "A test plants the earlier suite's change and expects the guard to pass, and a planted old name still fails."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Planted-change test

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000561-old-name-guard-fails-in-full-suite
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I plant the earlier suite's change, so that a test proves the guard ignores it.

## Functional Requirements
- The guard suite holds a case that plants a failing grep and an old name in an allowlisted file, in a scratch repo.
- The case expects the guard to pass.
- The planted-name cases from 0000189 and 0000192 keep their checks.

## Acceptance Criteria
- [ ] AC-1: the planted change passes
  - Given a scratch repo with a failing grep and a planted old name in an allowlisted file
  - When the guard runs on it
  - Then the guard reports no hit and passes
- [ ] AC-2: a planted old name still fails
  - Given a scratch repo with an old name planted in a file outside the allowlist
  - When the guard runs on it
  - Then the guard fails and names the file and line

## Dependencies
- REQ-001
