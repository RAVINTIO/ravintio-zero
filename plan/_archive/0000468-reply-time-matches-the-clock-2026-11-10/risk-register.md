---
title: "Risk Register - Reply time matches the clock"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Reply time matches the clock

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000468-reply-time-matches-the-clock
**Version:** 0.83.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A slow Stop hook pushes a correct time past the margin | low | low | The hook only warns, and the 5-minute margin covers normal delay | open |
| R-002 | technical | An older suite uses a fixed time and fails against the real clock | medium | low | The full suite shows each one, and `RAVINTIO_REPLY_CLOCK` fixes the clock | open |
| R-003 | operational | Hook and session run on different clocks, such as a container | low | low | The override variable lets a user set the clock | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The hook shares the session's clock | A warning on a correct time | open |
| A-002 | The hook runs right after the final reply | The margin absorbs the delay | open |
