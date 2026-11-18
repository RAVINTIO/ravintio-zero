---
title: "Requirement: REQ-003 - A test checks the printed order"
summary: "A suite checks that the printed rows ascend by version for a chart whose versions are out of chart order."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - A test checks the printed order

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000574-delivery-pr-lists-steps-in-version-order
**Version:** 0.143.0
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I run a test on a chart with out-of-order versions. A regression in the printed order then fails the suite.

## Functional Requirements
- The suite builds a chart where step 1 has the higher version.
- The suite reads the printed rows and compares their order with the version order.
- The suite also checks the replay order of the commits.

## Acceptance Criteria
- [ ] AC-1: the printed rows ascend by version
  - Given a chart where step 1 has version 0.59.0 and step 2 has 0.58.0
  - When the suite runs the script
  - Then the first row names step 2 and the second row names step 1
- [ ] AC-2: the table matches the replay
  - Given the same run
  - When the suite lists the new branch commits
  - Then the commit order matches the row order

## Dependencies
- REQ-002
