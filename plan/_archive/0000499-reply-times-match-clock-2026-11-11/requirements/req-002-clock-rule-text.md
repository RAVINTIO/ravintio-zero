---
title: "Requirement: REQ-002 - Clock rule text"
summary: "The standards and skills require a fresh clock read for every timestamp."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Clock rule text

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000499-reply-times-match-clock
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I find a rule that every timestamp comes from a fresh clock read.

## Functional Requirements
- Rule `reply-time-form` in `roadmap-standards.md` says that every timestamp comes from a clock read at that moment, and that an estimate is never acceptable.
- The rule names two sources: the latest time from the clock hook, and `date +%H:%M`.
- The initiative `SKILL.md` and `pipeline-reference.md` carry the same rule in one sentence.
- The orchestrator `SKILL.md` stays under its 9,000 byte cap and its text stays unchanged.

## Acceptance Criteria
- [ ] AC-1: the standards state the rule
  - Given `roadmap-standards.md`
  - When a reader opens rule `reply-time-form`
  - Then it requires a fresh clock read and bans an estimate
- [ ] AC-2: the skill and reference repeat it
  - Given the initiative `SKILL.md` and `pipeline-reference.md`
  - When a reader searches for the clock rule
  - Then each holds one sentence that names the clock hook and `date +%H:%M`
- [ ] AC-3: the orchestrator stays under its cap
  - Given the orchestrator `SKILL.md`
  - When you measure its size
  - Then it is 9,000 bytes or fewer

## Dependencies
- REQ-001 for the hook name.
