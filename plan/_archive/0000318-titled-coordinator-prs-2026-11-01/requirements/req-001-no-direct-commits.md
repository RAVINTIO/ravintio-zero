---
title: "Requirement: REQ-001 - no direct commits on the initiative branch"
summary: "The standards and the initiative skill name no direct commit on the initiative branch."
status: "active"
version: "0.44.0"
---
# Requirement: REQ-001 - no direct commits on the initiative branch

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000318-titled-coordinator-prs
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I want the roadmap standards and the initiative skill to route every coordinator change through a titled PR, so that the first-parent history is one titled squash per change.

## Functional Requirements

- `roadmap-standards.md` states that nothing commits directly on `initiative/*`.
- The queue, scope edit, and I-E Delivery text in the standards and the initiative skill no longer say "commit on the initiative branch".
- The initiative skill stays under 120 lines.

## Acceptance Criteria

- [ ] AC-1: the rule is stated
  - Given the roadmap standards
  - When a test searches them
  - Then they state that nothing commits directly on the initiative branch
- [ ] AC-2: the old wording is gone
  - Given the standards and the initiative skill
  - When a test searches them
  - Then neither tells the coordinator to commit directly on the initiative branch

## Dependencies

none
