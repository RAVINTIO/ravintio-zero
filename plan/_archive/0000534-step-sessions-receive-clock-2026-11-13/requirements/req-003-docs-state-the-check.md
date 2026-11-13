---
title: "Requirement: REQ-003 - Docs state the flag and the check"
summary: "The driver header, the standards, and an ADR state the flag, the check, and the proof run."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Docs state the flag and the check

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000534-step-sessions-receive-clock
**Source:** US-001, US-002
**Priority:** must-have

## User Story

As the human, I want the docs to state the flag, the check, and the proof, so that I find the evidence.

## Functional Requirements
- The header comment of `initiative-run.mjs` and the Step logs section of `roadmap-standards.md` name `--include-hook-events` and `step-clock-check.mjs`.
- ADR-0342 records the proof run, the log gap, and the machine zone finding. `docs/decisions-index.md` lists it.
- The tests README lists the new test file.

## Acceptance Criteria
- [ ] AC-1: the standards name the flag and the check
  - Given the Step logs section of `roadmap-standards.md`
  - When a reader looks for the hook events
  - Then the section names `--include-hook-events` and `step-clock-check.mjs`
- [ ] AC-2: the index lists the ADR
  - Given ADR-0342
  - When a reader opens `docs/decisions-index.md`
  - Then the index lists 0342

## Dependencies
- REQ-001 and REQ-002.
