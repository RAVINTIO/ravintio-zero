---
title: "Requirement: REQ-002 - Check needs a baseline file"
summary: "baseline-failures.mjs check exits 1 when no baseline file exists."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Check needs a baseline file

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000549-baseline-record-checks
**Source:** US-002
**Priority:** must-have

## User Story

As a step agent, I run `check`, so that a missing baseline file exits 1 with `no baseline recorded`.

## Functional Requirements
- If the baseline file does not exist, `check` prints `no baseline recorded` to stderr and exits 1.
- `check` prints no `new:` or `inherited:` line in that case.
- If the file exists, `check` behaves as before.

## Acceptance Criteria
- [ ] AC-1: Missing file is an error
  - Given no baseline file at the path
  - When the agent runs `check` on any runner output
  - Then the exit code is 1 and stderr holds `no baseline recorded`
- [ ] AC-2: Existing file still works
  - Given a baseline file that lists one suite
  - When the agent runs `check` on output that fails the same suite
  - Then the exit code is 0 and stdout holds `inherited:` for that suite

## Dependencies
- REQ-001 writes the file that `check` reads.
