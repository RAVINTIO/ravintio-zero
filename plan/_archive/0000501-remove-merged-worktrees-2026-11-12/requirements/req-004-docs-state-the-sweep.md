---
title: "Requirement: REQ-004 - Docs state the sweep"
summary: "The driver header comment, the standards, and an ADR state the sweep rule."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Docs state the sweep

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000501-remove-merged-worktrees
**Source:** US-001, US-002
**Priority:** must-have

## User Story

As the coordinator, I want the docs to state when the driver removes a merged worktree, so that I know why one stays.

## Functional Requirements
- The header comment of `initiative-run.mjs` states the sweep and the `Kept:` line.
- The "Concurrent steps" section of `roadmap-standards.md` states the sweep.
- ADR-0326 records the decision. `docs/decisions-index.md` lists it.
- `ravintio-zero/` holds the same files after `sync-installed.mjs`.

## Acceptance Criteria
- [ ] AC-1: driver header states the sweep
  - Given the driver source
  - When a reader opens the header comment
  - Then it names the merged-step sweep and `Kept:`
- [ ] AC-2: standards state the sweep
  - Given `roadmap-standards.md`
  - When a reader opens "Concurrent steps"
  - Then it names the sweep and the three keep rules

## Dependencies
- REQ-001, REQ-002, REQ-003.
