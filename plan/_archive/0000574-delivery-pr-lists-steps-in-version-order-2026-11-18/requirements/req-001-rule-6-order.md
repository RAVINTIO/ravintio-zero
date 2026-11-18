---
title: "Requirement: REQ-001 - Rule 6 names the table order"
summary: "I-E Delivery rule 6 says the step table lists steps in ascending Version order."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Rule 6 names the table order

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000574-delivery-pr-lists-steps-in-version-order
**Version:** 0.143.0
**Source:** US-001
**Priority:** must-have

## User Story

As a coordinator, I read in rule 6 that the step table ascends by `Version`. The PR body then matches the history.

## Functional Requirements
- Rule 6 of I-E Delivery in `roadmap-standards.md` says the table lists steps in ascending `Version` order.
- The rule says ascending `Version` is merge order.
- The rule says the script prints the table.

## Acceptance Criteria
- [ ] AC-1: rule 6 names the order
  - Given the I-E Delivery section of the standard
  - When a test reads rule 6
  - Then it names the step table, ascending `Version` order, and merge order
- [ ] AC-2: both trees match
  - Given the two pack trees
  - When a reader compares the standard
  - Then the files are identical

## Dependencies
- None
