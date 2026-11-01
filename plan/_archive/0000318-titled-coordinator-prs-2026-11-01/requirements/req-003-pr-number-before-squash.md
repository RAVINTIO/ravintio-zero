---
title: "Requirement: REQ-003 - ship records the PR number before the squash"
summary: "Ship writes the PR number into the changelog and pushes it before the squash."
status: "active"
version: "0.44.0"
---
# Requirement: REQ-003 - ship records the PR number before the squash

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000318-titled-coordinator-prs
**Source:** US-003
**Priority:** must-have

## User Story

As a reviewer, I want ship to record the PR number before the squash, so that no follow-up commit lands after it.

## Functional Requirements

- The ship skill and the I-D Advance stage state that the changelog `**PR:**` field is set and pushed before the squash.
- No text tells a step to commit the PR number after the squash.

## Acceptance Criteria

- [ ] AC-1: the order is stated
  - Given the ship skill
  - When a test searches it
  - Then it says the PR number is committed and pushed before the squash
- [ ] AC-2: the standards agree
  - Given the I-D Advance stage
  - When a test searches it
  - Then it orders the PR number commit before the squash-merge

## Dependencies

none
