---
title: "Requirement: REQ-001 - the orchestrator forbids forced adds"
summary: "The orchestrator skill forbids git add -f."
status: "active"
version: "0.43.0"
---
# Requirement: REQ-001 - the orchestrator forbids forced adds

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000317-block-forced-adds
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I want the orchestrator skill to forbid `git add -f`, so that a step never forces an ignored file into a commit.

## Functional Requirements

- The orchestrator `SKILL.md` states that a step never runs `git add -f` or `git add --force`.
- The text names the fix: if a file is ignored on purpose, leave it out. If it must be tracked, add a negation rule to `.gitignore`.
- The skill text stays within the skill-size budget.

## Acceptance Criteria

- [ ] AC-1: the rule is in the skill
  - Given the orchestrator `SKILL.md`
  - When a test searches it
  - Then it finds `git add -f`, `git add --force`, and `.gitignore`

## Dependencies

none
