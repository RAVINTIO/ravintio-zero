---
title: "Risk Register - Reply times match the clock"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Reply times match the clock

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000499-reply-times-match-clock
**Version:** 0.101.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | The 2 minute margin warns on a reply that follows a long tool call. | medium | low | The hook only warns and logs. The warning says the miss does not stop a run. | open |
| R-002 | technical | A settings merge in setup drops a user `PostToolUse` entry. | low | medium | The per-command filter keeps user commands. A suite checks a user entry survives. | open |
| R-003 | technical | The orchestrator `SKILL.md` has 13 bytes left under its 9,000 byte cap. | high | medium | The rule text goes to the standards and the initiative skill. `SKILL.md` stays unchanged. | open |
| R-004 | operational | The new hook adds a line of context after every tool call. | high | low | The line is under 40 characters. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Claude Code passes `additionalContext` from a `PostToolUse` hook to the model. | The hook adds nothing. The rule text still applies. | open |
