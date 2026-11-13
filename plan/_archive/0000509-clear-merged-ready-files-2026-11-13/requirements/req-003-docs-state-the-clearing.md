---
title: "Requirement: REQ-003 - Docs state the clearing"
summary: "The driver header comment, the standards, and an ADR state the clearing rule."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Docs state the clearing

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000509-clear-merged-ready-files
**Source:** US-001, US-002
**Priority:** must-have

## User Story

As the coordinator, I want the docs to state when the driver clears a ready file, so that I know why one stays.

## Functional Requirements
- The header comment of `initiative-run.mjs` states the clearing and the `Cleared:` and `Kept:` lines.
- The "Concurrent steps" section of `roadmap-standards.md` states the clearing.
- ADR-0340 records the decision. `docs/decisions-index.md` lists it.
- `ravintio-zero/` holds the same files after `sync-installed.mjs`.

## Acceptance Criteria
- [ ] AC-1: driver header states the clearing
  - Given the driver source
  - When a reader opens the header comment
  - Then it names the merged-step clearing and `Cleared:`
- [ ] AC-2: standards state the clearing
  - Given `roadmap-standards.md`
  - When a reader opens "Concurrent steps"
  - Then it names the clearing and the live-session keep rule

## Dependencies
- REQ-001, REQ-002.
