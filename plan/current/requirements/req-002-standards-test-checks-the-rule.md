---
title: "Requirement: REQ-002 - Standards test checks the rule"
summary: "A standards test fails if the I-D Advance rule loses the rebuild command or the failing check name."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Standards test checks the rule

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000547-step-merge-regenerates-index
**Source:** US-002
**Priority:** must-have

## User Story

As the human, I want a test to check the rule, so that a later edit cannot drop it.

## Functional Requirements
- A test reads the `### I-D Advance` section of the roadmap standards.
- The test asserts the rebuild command, the commit-before-push instruction, and the failing check name.
- The test exists in both pack trees.

## Acceptance Criteria
- [ ] AC-1: Test fails without the rule
  - Given the standards file without the rebuild rule
  - When the test runs
  - Then the test fails
- [ ] AC-2: Test passes with the rule
  - Given the standards file with the rule
  - When the test runs
  - Then the test passes

## Dependencies
- REQ-001
