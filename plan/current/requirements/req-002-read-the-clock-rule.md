---
title: "Requirement: REQ-002 - Read-the-clock rule"
summary: "Each place that states the reply form tells the step to read date +%H:%M before each reply."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Read-the-clock rule

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000468-reply-time-matches-the-clock
**Source:** US-002
**Priority:** must-have

## User Story

As a human on the loop, I find the instruction to read `date +%H:%M` before each reply wherever the reply form appears. Then steps read the clock.

## Functional Requirements
- `standards/roadmap-standards.md` (rule `reply-time-form`) tells the session to read `date +%H:%M` before each reply and to lead with that value.
- The orchestrator skill, the initiative skill, and the boot templates carry the same instruction.
- `standards/hook-enforcement.md` states the margin and the two override variables.
- The text says the check compares the time with the clock.

## Acceptance Criteria
- [ ] AC-1: the rule text names the command
  - Given the pack files that state the reply form
  - When a suite greps each for `date +%H:%M`
  - Then every file matches
- [ ] AC-2: the enforcement reference states the margin
  - Given `standards/hook-enforcement.md`
  - When a suite greps it
  - Then it names 5 minutes and `RAVINTIO_REPLY_CLOCK`

## Dependencies
- REQ-001
