---
title: "Requirement: REQ-002 - Clock check"
summary: "A script reads a step log and fails when the log holds tool calls and no clock output."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Clock check

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000534-step-sessions-receive-clock
**Source:** US-002
**Priority:** must-have

## User Story

As the human, I want a check that fails when a step log shows no clock, so that I find a silent step.

## Functional Requirements
- `step-clock-check.mjs {log}` reads one step log and writes nothing.
- A hook event counts as clock output when it has `hook_event` `PostToolUse`, subtype `hook_response`, and an `output` that holds `Local time: hh:mm`.
- The script counts `tool_use` items in `assistant` events.
- With tool calls and no clock output, it exits 1 and prints `Blocked: {log} holds {n} tool calls and no clock output.`
- Otherwise it exits 0 and prints the counts. A log with no tool calls prints that it has nothing to check.
- A missing log or a missing argument exits 2 with a usage line. It never prints log text.

## Acceptance Criteria
- [ ] AC-1: a log with clock output passes
  - Given a log with one tool call and one `PostToolUse` clock output
  - When the script runs on it
  - Then it exits 0
- [ ] AC-2: a log with no clock output fails
  - Given a log with two tool calls and no hook events
  - When the script runs on it
  - Then it exits 1 and prints `no clock output`
- [ ] AC-3: a log with no tool calls passes
  - Given a log with one text event
  - When the script runs on it
  - Then it exits 0 and prints `nothing to check`

## Dependencies
- The stream-json event shapes that REQ-001 makes the log hold.
