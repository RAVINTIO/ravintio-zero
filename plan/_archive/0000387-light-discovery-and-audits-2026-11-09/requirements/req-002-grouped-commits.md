---
title: "Requirement: REQ-002 - Grouped coaching commits"
summary: "Grouped coaching commits"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Grouped coaching commits

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000387-light-discovery-and-audits
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I want coaching records grouped by topic into one commit, so that P0 history shows a few topic commits.

## Functional Requirements

- `orchestrator-discovery-records.md` states which records group into one commit per topic, such as scope or acceptance criteria. A topic commits when it closes or when the session pauses.
- A requirement, an ADR, and `design.md` still commit at once. Any record commits at once when the session may end.
- Hard Limit 8 in the orchestrator skill and the boot template point to the grouping rule.

## Acceptance Criteria

- [ ] AC-1: Grouping rule
  - Given the discovery records reference
  - When a reader looks for commit grouping
  - Then it names the records that group and when a topic commits
- [ ] AC-2: Immediate commits
  - Given the same reference
  - When a reader looks for artifacts
  - Then it requires an immediate commit for each requirement, ADR, and design.md
- [ ] AC-3: Pointers
  - Given Hard Limit 8 and the boot template
  - When a reader opens them
  - Then each points to the grouping rule and the size caps hold

## Dependencies

- None.
