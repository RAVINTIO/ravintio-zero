---
title: "Requirement: REQ-005 - Major-bump coaching"
summary: "Major-bump coaching"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - Major-bump coaching

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000387-light-discovery-and-audits
**Source:** US-005
**Priority:** must-have

## User Story

As a maintainer, I want coaching to ask whether a major bump is pre-approved for an advisory fix, so that P2 does not stop on it.

## Functional Requirements

- `orchestrator-p0-coaching.md` adds a question for advisory-fix stories. It asks whether a major bump of an existing dependency is pre-approved when it is the only fix.
- The answer goes in `Approved dependencies` in `design.md`.

## Acceptance Criteria

- [ ] AC-1: Question
  - Given the P0 coaching reference
  - When a story targets advisories
  - Then it asks the major-bump question
- [ ] AC-2: Record
  - Given an answer
  - When coaching records it
  - Then the answer sits in Approved dependencies

## Dependencies

- None.
