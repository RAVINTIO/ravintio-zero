---
title: "Requirement: REQ-004 - Filing skill runs the wording check"
summary: "Filing skill runs the wording check"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Filing skill runs the wording check

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000393-session-integrity-and-guards
**Source:** US-004
**Priority:** should-have

## User Story

As a maintainer, I want the filing skill to run the wording check, so that a bad entry fails when filed.

## Functional Requirements

- `ravintio-zero/scripts/check-entry-wording.mjs {file}...` applies the pack wording rules to the files and prints `path:line` for each breach.
- It exits 1 on any breach and 0 otherwise. It uses only allowlist entries that the pack tests also accept.
- `ravintio-file-backlog` runs it on the new entry before it reports the path, and reports a breach.

## Acceptance Criteria

- [ ] AC-1: Breach found
  - Given a fixture entry with a banned phrase
  - When the check runs on it
  - Then it exits 1 and prints the file and line
- [ ] AC-2: Clean entry
  - Given a clean fixture entry
  - When the check runs on it
  - Then it exits 0
- [ ] AC-3: Skill wired
  - Given the filing skill
  - When a reader opens Step 6
  - Then it runs the check before Step 7

## Dependencies

- None.
