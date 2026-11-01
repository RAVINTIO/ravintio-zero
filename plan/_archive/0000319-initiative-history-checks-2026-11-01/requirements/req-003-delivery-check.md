---
title: "Requirement: REQ-003 - delivery check and PR title"
summary: "I-E Delivery runs the script."
status: "active"
version: "0.45.0"
---
# Requirement: REQ-003 - delivery check and PR title

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000319-initiative-history-checks
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I see I-E Delivery run the script and put the merge commit instruction in the PR title and body top, so that the landing button shows how to merge.

## Functional Requirements

- I-E Delivery in the roadmap standards runs the script before it raises the initiative PR, lists each failing commit in the PR body, and stops.
- The PR title and the first line of the body both say to merge with a merge commit.
- The initiative skill's I-E Delivery section points to the standards.

## Acceptance Criteria

- [ ] AC-1: the delivery step
  - Given the roadmap standards
  - When a test reads I-E Delivery
  - Then it names the script, the failing commits in the body, and the stop
- [ ] AC-2: the title and body
  - Given the roadmap standards
  - When a test reads I-E Delivery
  - Then it names the merge commit instruction in the title and at the top of the body

## Dependencies

REQ-001
