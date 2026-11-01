---
title: "Requirement: REQ-001 - once-per-session trigger"
summary: "The orchestrator load instruction fires once per session."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - once-per-session trigger

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000320-quiet-session-start
**Source:** US-001
**Priority:** must-have

## User Story

As a developer, I see the load instruction once per session, so that I read it when it matters.

## Functional Requirements
- `auto-trigger-orchestrator.mjs` records the `session_id` in `plan/.orchestrator-loaded` when it emits the instruction.
- The hook emits the instruction only when the recorded id differs from the current `session_id`.
- If the payload has no `session_id`, the hook emits as it does today and writes nothing.
- The hook adds `plan/.orchestrator-loaded` to `.git/info/exclude` once. This repo also lists it in `.gitignore`.
- `check-orchestrator-presence.mjs` applies the same rule to its advisory banner. Strict mode keeps its ack rule.
- Both hooks keep exit code 0.

## Acceptance Criteria
- [ ] AC-1: first prompt gets the instruction
  - Given a ravintio project with no `plan/.orchestrator-loaded`
  - When the hook receives a prompt with session id A
  - Then it emits the load instruction and records A
- [ ] AC-2: second prompt gets none
  - Given the record holds session id A
  - When the hook receives another prompt with session id A
  - Then it emits nothing
- [ ] AC-3: new session gets the instruction again
  - Given the record holds session id A
  - When the hook receives a prompt with session id B
  - Then it emits the instruction and records B

## Dependencies
- Claude Code passes `session_id` to `UserPromptSubmit` hooks (confirmed 2026-11-01).
