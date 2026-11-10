---
title: "Requirement: REQ-001 - Retrospective record"
summary: "One record that covers every stop and mistake in initiative 0000360."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Retrospective record

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000421-initiative-retrospective
**Source:** US-001
**Priority:** must-have

## User Story

As a human on the loop, I read one record of every stop, so that I know each cause and what remains open.

## Functional Requirements
- The record sits at `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.
- Each of the 27 rows in `coordinator-evidence.md` has a 5 whys chain that ends at a gap in a process, check, standard, or tool.
- Each row has a verdict. "Addressed by {feature id or PR}" cites evidence. Otherwise the verdict is "unaddressed".
- Rows that share one cause group into one finding.
- The record names no person and no agent.

## Acceptance Criteria
- [ ] AC-1: Every row has a verdict
  - Given the 27 rows in the evidence file
  - When a reader searches the record for each row number
  - Then each row appears with a 5 whys chain and a verdict
- [ ] AC-2: Blameless wording
  - Given the finished record
  - When a reader scans every chain
  - Then each chain ends at a gap in a process, check, standard, or tool

## Dependencies
- `plan/current-initiative/coordinator-evidence.md`
- The `ravintio-retrospective` skill
