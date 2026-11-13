---
title: "Risk Register - Step sessions receive the clock"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.112.0"
---
# Risk Register - Step sessions receive the clock

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000534-step-sessions-receive-clock
**Version:** 0.112.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | Step logs grow because each tool call adds hook events | medium | low | Each event is short. The log is in an ignored folder. | accepted |
| R-002 | technical | A later CLI renames the flag and the stub still accepts it | low | medium | The check fails on a real log that has no hook events. | open |
| R-003 | operational | The step 48 time came from a zone difference, so the flag changes nothing for the human | medium | low | The ADR records the finding and the check shows the clock arrived. | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The proof run represents a step session | The check on a real step log still shows the gap | open |
| A-002 | The machine zone explains the step 48 time | The check on the next step log shows whether the clock arrived | open |
