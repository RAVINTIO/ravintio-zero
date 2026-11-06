---
title: "Requirement: REQ-005 - Delivery rules and the initiative skill name the reshape"
summary: "I-E Delivery and the initiative skill state the reshape, the tag move, and the cleanup."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - Delivery rules and the initiative skill name the reshape

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000353-reshape-at-delivery
**Source:** US-004
**Priority:** must-have

## User Story

As a coordinator, I read the reshape, the tag move, and the cleanup in the delivery rules and the initiative skill.

## Functional Requirements
- `### I-E Delivery` in the roadmap standards runs the reshape after the archive and retrospective PRs and before the history check. It names the script, the new branch, `--tags` and `--push`, the stop on a conflict, and the PR from the reshaped branch.
- It says to close any PR from the old branch, and to delete the old branch after the human merges.
- It says the coordinator never force-pushes a branch or a tag.
- The initiative skill's `## I-E Delivery` points to the reshape and stays under 120 lines.

## Acceptance Criteria
- [ ] AC-1: standards text
  - Given the I-E Delivery section
  - When a test reads it
  - Then it names `reshape-initiative.mjs`, `-reshaped`, the old tag delete, and the old branch delete
- [ ] AC-2: skill size
  - Given the initiative skill
  - When a test counts lines
  - Then it holds at most 120

## Dependencies
- REQ-001, REQ-002.
