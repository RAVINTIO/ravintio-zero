---
title: "Requirement: REQ-003 - Tighter reply check"
summary: "The reply hook warns on a time over 2 minutes off the clock and on an unknown status."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Tighter reply check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000499-reply-times-match-clock
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I see a warning when a reply time is over 2 minutes off the clock or the status is unknown.

## Functional Requirements
- The default margin of `check-reply-prefix.mjs` is 2 minutes. `RAVINTIO_REPLY_MARGIN_MIN` still replaces it.
- After a valid prefix, the status must be `Starting:`, `Resuming:`, `Complete:`, `Question:`, `Blocked:`, `Skipped:`, `Ready:`, or `Restart:`. The hook skips a prefix with no status. Any other status warns.
- A status miss draws the same warning style, names the "Status check", and logs `{ISO timestamp} status: {first 80 characters}` to `plan/.prefix-misses.log`.
- A reply that already fails the prefix or clock check draws that warning only.
- The hook warns only and exits 0 in every case.

## Acceptance Criteria
- [ ] AC-1: a 3 minute gap warns
  - Given the clock is `10:00` and a reply starts `10:03 P2 Implement: Starting: x`
  - When the Stop hook runs
  - Then it warns about the clock and logs one line
- [ ] AC-2: an unknown status warns
  - Given a reply `10:00 P4 Ship: Running: x` at clock `10:00`
  - When the Stop hook runs
  - Then it warns with the Status check and logs a `status:` line
- [ ] AC-3: valid replies pass and the hook exits 0
  - Given a reply `10:02 P4 Ship: Complete: x` at clock `10:00`
  - When the Stop hook runs
  - Then it prints nothing and exits 0

## Dependencies
- 0000468 ADR-0305 for the clock check.
