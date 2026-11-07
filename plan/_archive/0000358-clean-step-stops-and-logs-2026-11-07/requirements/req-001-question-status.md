---
title: "Requirement: REQ-001 - question status"
summary: "The status set names `Question` everywhere it is listed, and `Blocked:` stays for exception stops."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - question status

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000358-clean-step-stops-and-logs
**Source:** US-001
**Priority:** must-have

## User Story

As a human on the loop, I see `Question:` on a routine question, so that `Blocked:` marks only an exception stop.

## Functional Requirements
- The status set reads Starting, Resuming, Complete, Question, Blocked, or Skipped in the orchestrator skill, `pipeline-reference.md`, `standard-boot.md`, and `codex-boot.md`. This repo's `CLAUDE.md` is generated from the boot template and ignored by git, so setup carries the change and the local copy is edited by hand.
- The orchestrator skill adds one line: `Question:` is for a routine question to the human, and `Blocked:` is for an exception stop.
- The product id check in the start actions reference uses `Question:`. Every other `Blocked:` line stays.
- The comment in `check-reply-prefix.mjs` lists the status set. The hook logic does not change.
- Resume detection and the governance counts keep reading `Blocked:`.

## Acceptance Criteria
- [ ] AC-1: status set names Question
  - Given the five files that list the status set
  - When a test reads each
  - Then each names `Question` and `Blocked`
- [ ] AC-2: Blocked reserved for exception stops
  - Given the orchestrator skill and the start actions reference
  - When a test reads them
  - Then the product id check line starts `P0 Discovery: Question:` and the skill states the split
- [ ] AC-3: resume reads Blocked
  - Given the resume detection reference
  - When a test reads it
  - Then it still names `Blocked` and does not name `Question`

## Dependencies
- None.
