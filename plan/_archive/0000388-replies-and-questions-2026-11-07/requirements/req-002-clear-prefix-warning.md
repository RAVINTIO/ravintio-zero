---
title: "Requirement: REQ-002 - Clear prefix warning"
summary: "The prefix warning names the check, quotes the reply, names the session, and skips the coordinator while a driver step runs."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-002 - Clear prefix warning

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000388-replies-and-questions
**Source:** US-002
**Priority:** must-have

## User Story

> One requirement doc = one user story.

As a human on the loop, I see a prefix warning that names the check, quotes the reply, and names the session, so that I don't read it as a stopped run.

Backlog entry: 0000258.

## Functional Requirements
- The warning starts with "Reply prefix check".
- The warning quotes the first words of the flagged reply, at most 80 characters.
- The warning names the session, either a step session or the coordinator.
- The warning never says or implies that the run stopped.
- The hook skips the check when `RAVINTIO_INITIATIVE_STEP` is not `1` and `plan/.initiative-runner.lock` exists under the working directory (see ADR-001).
- The hook never blocks a turn.

## Acceptance Criteria
- [ ] AC-1: Warning names check, reply, and session
  - Given a reply with no valid prefix
  - When the Stop hook runs
  - Then the message names "Reply prefix check"
  - And it quotes the first words of the reply and names the session
  - And it doesn't read as a stopped run
- [ ] AC-2: Coordinator skip while the driver lock is held
  - Given `RAVINTIO_INITIATIVE_STEP` is not `1` and `plan/.initiative-runner.lock` exists
  - When the Stop hook runs on a reply with no prefix
  - Then it logs no miss and prints no warning
  - And it exits 0

## Dependencies
- REQ-001, which edits the same hook file.
- ADR-001.

## Input Validation

- [ ] Input source: hook stdin field (the transcript reply text) and env var `RAVINTIO_INITIATIVE_STEP`
- [ ] Allowed character pattern: printable text, control characters stripped before the quote
- [ ] maximum length: 80 characters, content beyond this limit is truncated
- [ ] Failure behaviour: exit with code 0 and print nothing
- [ ] Logging policy: sanitised value only in output
