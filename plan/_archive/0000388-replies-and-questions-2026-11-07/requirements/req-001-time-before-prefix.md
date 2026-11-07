---
title: "Requirement: REQ-001 - Time before reply prefix"
summary: "The hooks inject the local time and accept a leading hh:mm before a reply prefix."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-001 - Time before reply prefix

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000388-replies-and-questions
**Source:** US-001
**Priority:** must-have

## User Story

> One requirement doc = one user story.

As a human on the loop, I see `hh:mm` before every reply and driver line, so that I know when each happened.

Backlog entry: 0000257.

## Functional Requirements
- `check-design.mjs` adds the current local time as `hh:mm` to the `additionalContext` it outputs.
- `check-reply-prefix.mjs` accepts a leading `hh:mm ` before any valid prefix.
- `check-reply-prefix.mjs` logs a miss for a reply with a time and no prefix.
- The hook exits 0 on every input.

## Acceptance Criteria
- [ ] AC-1: Time prefix accepted
  - Given a transcript whose last reply starts `06:43 I-C Run: Starting: x`
  - When the Stop hook runs
  - Then it logs no miss and prints no warning
  - And the same holds for `06:43 P0 Discovery: Starting: x`
- [ ] AC-2: Missing prefix still logged
  - Given a transcript whose last reply has neither a prefix nor a time
  - When the Stop hook runs
  - Then it appends one line to `plan/.prefix-misses.log`
  - And it exits 0
- [ ] AC-3: Hook injects the time
  - Given a confirmed design and a UserPromptSubmit payload
  - When `check-design.mjs` runs
  - Then the `additionalContext` holds the current local time as `hh:mm`

## Dependencies
- None. REQ-002 edits the same hook file and runs in the same unit.
