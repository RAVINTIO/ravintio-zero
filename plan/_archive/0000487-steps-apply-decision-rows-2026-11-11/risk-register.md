---
title: "Risk Register - Steps apply the chart's Decisions rows"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Steps apply the chart's Decisions rows

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000487-steps-apply-decision-rows
**Version:** 0.95.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A fork text holds a colon or a pipe and the line match fails. | medium | low | The match compares the text after the fixed prefix, trimmed, and a test covers a colon. | open |
| R-002 | operational | A step logs a line for each row without applying it. | medium | medium | The check requires a line only. The retrospective reads the log against the rows. | open |
| R-003 | operational | An old chart row names a step that is already merged. | low | low | The check runs on the current step only. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The build log Feature ID equals the chart Feature id column. | The check skips. | open |
| A-002 | A Fork text is unique within its step. | One log line covers two rows. | open |
