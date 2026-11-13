---
title: "Requirement: REQ-001 - Driver records hook events"
summary: "The driver starts every step session with --include-hook-events, so the step log holds the hook output."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Driver records hook events

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000534-step-sessions-receive-clock
**Source:** US-001
**Priority:** must-have

## User Story

As the human, I want each step log to hold the hook output, so that I can see what the step session received.

## Functional Requirements
- `runStep` in `initiative-run.mjs` adds `--include-hook-events` right after `--verbose`.
- A first run and a resumed run both carry the flag.
- The step log keeps mode 600. The watcher output does not change.

## Acceptance Criteria
- [ ] AC-1: a first run carries the flag
  - Given a stub `claude` that records its arguments
  - When the driver starts a step
  - Then the arguments hold `--verbose --include-hook-events --permission-mode auto`
- [ ] AC-2: a resumed run carries the flag
  - Given a step that ends its turn unmerged
  - When the driver resumes it
  - Then the resume arguments also hold `--include-hook-events`

## Dependencies
- `runStep` in `initiative-run.mjs`.
