---
title: "Requirement: REQ-001 - Clock hook"
summary: "A PostToolUse hook returns the local time after every tool call, and setup wires it once."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Clock hook

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000499-reply-times-match-clock
**Source:** US-001
**Priority:** must-have

## User Story

As an agent, I get the current local time after every tool call, so that I never estimate a time.

## Functional Requirements
- `clock-context.mjs` is a `PostToolUse` hook for all tools. It prints one JSON object on stdout.
- The object is `{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"Local time: hh:mm"}}`.
- The time is the local clock. `RAVINTIO_REPLY_CLOCK` (hh:mm) replaces it for tests, as in the reply hook.
- The hook reads no input, no file, and no network. It exits 0 in every case.
- `setup.sh` and `setup.ps1` wire the hook with the advisory launcher. A rerun adds no second entry, and a user `PostToolUse` entry survives.
- `install-lifecycle.mjs` and `pack-facts.json` list the hook.

## Acceptance Criteria
- [ ] AC-1: the hook returns the current time
  - Given `RAVINTIO_REPLY_CLOCK` is `13:42`
  - When the hook runs
  - Then it prints JSON whose `additionalContext` holds `13:42` and exits 0
- [ ] AC-2: setup wires the hook once
  - Given a scratch project with a user `PostToolUse` entry
  - When `setup.sh` runs twice
  - Then settings hold one `clock-context` entry and the user entry
- [ ] AC-3: the pack lists the hook
  - Given `install-lifecycle.mjs` and `pack-facts.json`
  - When a reader looks for `clock-context`
  - Then both name it with event `PostToolUse` and mode `advisory`

## Dependencies
- None.
