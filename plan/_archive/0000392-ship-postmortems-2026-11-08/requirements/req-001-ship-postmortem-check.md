---
title: "Requirement: req-001 - Ship postmortem check"
summary: "Ship postmortem check."
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - Ship postmortem check

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000392-ship-postmortems
**Source:** US-001
**Priority:** must-have

## User Story

As a reviewer, I see ship fail when a stop or a rework has no postmortem, so that every stop leaves a record.

## Functional Requirements

- `build-log-check.mjs` counts each `Resolved:` line and each distinct `REQ-nnn` in a `Rework:` line.
- Each `Postmortem: {path}` line needs a record at that path. A `Postmortem:` line that names a `REQ-nnn` covers that requirement. Any other `Postmortem:` line covers one `Resolved:` line.
- The check runs `postmortem-check.mjs` on each named record.
- The orchestrator runs `ravintio-postmortem` for each rework requirement before ship.
- A session that finds a `Blocked:` line cleared outside the session writes the `Resolved:` line before it continues.

## Acceptance Criteria

- [ ] AC-1: Resolved line with no postmortem fails
  - Given a build log with a `Resolved:` line and no `Postmortem:` line
  - When ship runs `build-log-check.mjs`
  - Then the check exits 1 and names the missing postmortem
- [ ] AC-2: Rework with no postmortem fails
  - Given a build log with `Rework: REQ-002` and no `Postmortem:` line that names `REQ-002`
  - When ship runs `build-log-check.mjs`
  - Then the check exits 1 and names `REQ-002`
- [ ] AC-3: Covered stop and rework pass
  - Given a build log whose stop and rework each have a `Postmortem:` line and a valid record
  - When ship runs `build-log-check.mjs`
  - Then the check reports no postmortem finding

## Dependencies

- None
