---
title: "Requirement: REQ-004 - Question form"
summary: "The coaching reference sets a choice menu for closed questions, plain text for open ones, and all, some, change options for list approval."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-004 - Question form

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000388-replies-and-questions
**Source:** US-004
**Priority:** must-have

## User Story

> One requirement doc = one user story.

As a human on the loop, I get a choice menu for closed decisions and plain text for open questions, so that closed decisions take one click.

Backlog entry: 0000306.

## Functional Requirements
- `orchestrator-discovery-coaching.md` states the closed-question rule (use the choice tool) with an example.
- It states the open-question rule (plain text) with an example.
- It states the list-approval rule with the all, some, and change options.
- It names the text fallback for a host with no choice tool.
- Each rule sits behind a `<!-- rule: id -->` anchor.

## Acceptance Criteria
- [ ] AC-1: Closed and open rules
  - Given the question rule anchors in `orchestrator-discovery-coaching.md`
  - When a test reads them
  - Then the text states the closed-question rule (choice tool) and the open-question rule (plain text)
  - And each rule holds an example
- [ ] AC-2: List approval
  - Given the list-approval anchor
  - When a test reads it
  - Then the text names the all, some, and change options
  - And it names the text fallback for a host with no choice tool

## Dependencies
- Rule anchor helpers in `ravintio-zero/tests/helpers/` (feature 0000380).
