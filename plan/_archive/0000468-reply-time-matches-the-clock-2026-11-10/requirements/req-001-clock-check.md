---
title: "Requirement: REQ-001 - Clock check"
summary: "The reply check compares a leading hh:mm with the local clock and warns when the difference passes the margin."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Clock check

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000468-reply-time-matches-the-clock
**Source:** US-001
**Priority:** must-have

## User Story

As a human on the loop, I see a warning when a reply time differs from the clock by more than the margin. Then a wrong time does not pass.

## Functional Requirements
- `check-reply-prefix.mjs` reads the leading `hh:mm` of the first line and compares it with the local clock.
- The difference is the shorter way round the day, so 23:58 and 00:02 differ by 4 minutes.
- The margin is 5 minutes. A difference of 5 minutes or less passes.
- A time beyond the margin is a miss. The hook adds one log line to `plan/.prefix-misses.log` and writes the warning, and the warning names the time and the clock.
- A time with no valid prefix is still a miss.
- `RAVINTIO_REPLY_CLOCK` (`hh:mm`) replaces the clock, and `RAVINTIO_REPLY_MARGIN_MIN` replaces the margin. A value that does not parse leaves the default.
- The hook still exits 0 on every path.

## Acceptance Criteria
- [ ] AC-1: a time inside the margin passes
  - Given a clock of 14:30 and a reply that starts `14:34 P2 Implement: Starting: x`
  - When the hook runs
  - Then it exits 0 with no output and no log line
- [ ] AC-2: a time outside the margin warns
  - Given a clock of 14:30 and a reply that starts `13:30 P2 Implement: Starting: x`
  - When the hook runs
  - Then it exits 0, writes a warning that names 13:30 and 14:30, and adds one log line
- [ ] AC-3: the check wraps at midnight
  - Given a clock of 00:02 and a reply that starts `23:58 P2 Implement: Starting: x`
  - When the hook runs
  - Then it exits 0 with no output
  - And a reply that starts `23:50` warns

## Dependencies
- none
