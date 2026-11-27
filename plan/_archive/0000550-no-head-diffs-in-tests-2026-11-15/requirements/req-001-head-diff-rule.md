---
title: "Requirement: REQ-001 - HEAD diff rule"
summary: "The testing standard bans comparing the working tree with HEAD or a moving ref."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - HEAD diff rule

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000550-no-head-diffs-in-tests
**Source:** US-001
**Priority:** must-have

## User Story

As a test author, I read a rule that bans diffing against `HEAD`, so that my test keeps its meaning after a commit.

## Functional Requirements
- `testing-standards.md` holds a rule with the anchor `<!-- rule: tests-no-head-diff -->`.
- The rule says a test never compares the working tree with `HEAD` or a moving ref.
- The rule names a fixed base commit or a planted fixture as the fix.

## Acceptance Criteria
- [ ] AC-1: Rule present
  - Given the standards in `ravintio-zero/standards/`
  - When a reader opens `testing-standards.md`
  - Then the rule `tests-no-head-diff` names `HEAD` and a moving ref.
- [ ] AC-2: Pack copies match
  - Given the rule exists in `src/ravintio-zero/`
  - When the sync check runs
  - Then `ravintio-zero/` holds the same text.

## Dependencies
- None.
