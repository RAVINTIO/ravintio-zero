---
title: "Requirement: REQ-003 - Explicit agreement"
summary: "The recommend-then-confirm rule asks for Yes, I agree and one permission per question."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-003 - Explicit agreement

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000388-replies-and-questions
**Source:** US-003
**Priority:** must-have

## User Story

> One requirement doc = one user story.

As a human on the loop, I am asked for "Yes, I agree" and one permission per question, so that the agent acts only on permissions I grant.

Backlog entry: 0000259.

## Functional Requirements
- The rule sits behind `<!-- rule: id -->` anchors in `orchestrator-p0-coaching.md` and in the initiative skill.
- Each phase skill that asks for approval points to the rule.
- The rule treats "Ok" as ambiguous and asks for "Yes, I agree".
- The rule asks the human to name the option when more than one is outstanding.
- The rule asks for one permission per question and numbers each permission in a multi-permission question.
- The rule asks again when a reply names no permission.
- The orchestrator `SKILL.md` stays at or under 9000 bytes.

## Acceptance Criteria
- [ ] AC-1: Agreement wording
  - Given the recommend-then-confirm rule anchors
  - When a test reads them
  - Then the text names "Ok" as ambiguous and asks for "Yes, I agree"
  - And it asks the human to name the option when more than one is outstanding
- [ ] AC-2: One permission per question
  - Given the same anchors
  - When a test reads them
  - Then the text asks for one permission per question and numbers each permission in a multi-permission question
  - And it asks again when a reply names none

## Dependencies
- Rule anchor helpers in `ravintio-zero/tests/helpers/` (feature 0000380).
