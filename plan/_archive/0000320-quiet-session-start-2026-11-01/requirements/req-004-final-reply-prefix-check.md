---
title: "Requirement: REQ-004 - final-reply prefix check"
summary: "The prefix check reads the final reply and warns only on a missing prefix."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - final-reply prefix check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000320-quiet-session-start
**Source:** US-003
**Priority:** must-have

## User Story

As a developer, I get a prefix warning only when the final reply lacks a prefix, so that I trust the warning.

## Functional Requirements
- `check-reply-prefix.mjs` checks `last_assistant_message` from the Stop payload when it is a string with text.
- If the field is absent, the hook reads the transcript and takes the last assistant message that follows the last user prompt and has no `tool_use` block. It rereads up to 4 times over about 1 second.
- If it finds no final reply, it exits 0 with no output and no log line.
- A warning quotes the checked reply in the log, as today.
- The hook stays advisory and always exits 0.

## Acceptance Criteria
- [ ] AC-1: prefixed final reply gives no warning
  - Given a payload whose final reply has a valid prefix and whose transcript holds an earlier unprefixed note
  - When the Stop hook runs
  - Then it prints nothing and logs nothing
- [ ] AC-2: unprefixed final reply warns and quotes it
  - Given a payload whose final reply lacks a prefix
  - When the Stop hook runs
  - Then it warns and the log snippet quotes that reply
- [ ] AC-3: no final reply gives no warning
  - Given a payload with no `last_assistant_message` and a transcript that ends on a `tool_use` block
  - When the Stop hook runs
  - Then it prints nothing and logs nothing

## Dependencies
- Claude Code passes `last_assistant_message` to Stop hooks (confirmed 2026-11-01).
