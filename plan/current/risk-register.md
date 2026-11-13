---
title: "Risk Register - Driver prints a stop summary"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.111.0"
---
# Risk Register - Driver prints a stop summary

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000511-driver-stop-summary
**Version:** 0.111.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The summary throws and hides the original stop | low | medium | The printer sits in a `try` block and writes only strings. | open |
| R-002 | operational | A reader of driver output meets a new line kind | low | low | The lines use a new `Summary:` status and print after every other line. | open |
| R-003 | operational | The recorder misses a fix that has no matching line | medium | low | The full output still holds it. The summary lists only fixes with a line. | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The existing merge and fix lines name every merge and fix | The summary omits a fix, and the full output still holds it | open |
| A-002 | A stop line decides the action | The generic action still points at the stop line | open |
