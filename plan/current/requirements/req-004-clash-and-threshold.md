---
title: "Requirement: REQ-004 - Clash and threshold check"
summary: "The use command checks slots, files, and thresholds before it writes."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-004 - Clash and threshold check

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000391-standards-archetypes
**Source:** US-004
**Priority:** must-have

## User Story

> One requirement doc = one user story.

As a pack user, I pick several archetypes, so that the command reports a clash and no archetype lowers another's threshold.

## Functional Requirements
- Two archetypes that claim one slot clash.
- Two archetypes that carry the same override file clash.
- A pick whose threshold is lower than an installed archetype's threshold fails.
- The command runs all three checks before it writes any file.
- A failed check prints each problem, exits 1, and copies nothing.

## Acceptance Criteria
- [ ] AC-1: Slot clash
  - Given an installed archetype that claims the `stack` slot
  - When the user picks a second archetype that claims `stack`
  - Then the command prints the clash, exits 1, and copies nothing
- [ ] AC-2: File clash
  - Given an installed archetype that carries a file
  - When the user picks a different archetype that carries the same file
  - Then the command prints the clash, exits 1, and copies nothing
- [ ] AC-3: Threshold lowered
  - Given an installed archetype with a mutation score threshold of 80
  - When the user picks an archetype with a threshold of 60
  - Then the command prints the problem, exits 1, and copies nothing

## Dependencies
- REQ-003 archetype command.
- ADR-0294 records the check order.
