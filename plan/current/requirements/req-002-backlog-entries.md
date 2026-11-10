---
title: "Requirement: REQ-002 - Backlog entries"
summary: "One backlog entry for each unaddressed finding, in a suggested step order."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Backlog entries

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000421-initiative-retrospective
**Source:** US-002
**Priority:** must-have

## User Story

As a coordinator, I get one backlog entry per unaddressed finding, so that I can chart the fixes as steps 23 onward.

## Functional Requirements
- Each unaddressed finding has one entry with `priority: "high"` and `theme: "initiative"`.
- If an open entry already covers a finding, the record cites that entry and files no new one.
- The record marks each finding whose fix would widen a guard. It names the guard and the new forms it would allow.
- The record lists the entries in a suggested step order with `Lane` and `After` for each.
- The step reserves ids with `node ravintio-zero/scripts/reserve-id.mjs` and rebuilds the index with `node ravintio-zero/scripts/backlog-index.mjs`.

## Acceptance Criteria
- [ ] AC-1: Every unaddressed finding names an entry
  - Given a finding with the verdict "unaddressed"
  - When a reader looks up the finding in the record
  - Then it names one backlog entry id
- [ ] AC-2: Suggested order
  - Given the filed entries
  - When a reader opens the suggested step order
  - Then each entry has a `Lane` and an `After` value

## Dependencies
- REQ-001
