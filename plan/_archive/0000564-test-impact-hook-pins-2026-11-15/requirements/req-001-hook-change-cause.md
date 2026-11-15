---
title: "Requirement: REQ-001 - Hook change cause"
summary: "The scan lists the greps for suites that pin a hook when a run adds, removes, or changes one."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Hook change cause

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000564-test-impact-hook-pins
**Version:** 0.122.0
**Source:** US-001
**Priority:** must-have

## User Story

As a plan author, I see a `Hook change` cause, so that I grep the tests for four hook pins.

## Functional Requirements
- The reference file holds a `Hook change` cause.
- The cause fires when the run adds, removes, or changes a hook.
- The cause names four grep targets.
- The targets are the hook name, hook count words, and the `expected-after.txt` fixture with `pack-facts`.
- The fourth target is the margin or status text the hook checks.

## Acceptance Criteria
- [ ] AC-1: cause named
  - Given the reference file
  - When a reader looks for the cause
  - Then it reads `Hook change`
- [ ] AC-2: four targets listed
  - Given the cause
  - When a run changes a hook
  - Then the cause names the hook name and count words
  - And it names the fixture with `pack-facts` and the margin or status text
- [ ] AC-3: both trees match
  - Given the two pack trees
  - When a reader compares the reference file
  - Then the files are identical

## Dependencies
- None
