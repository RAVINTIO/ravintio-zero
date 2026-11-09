---
title: "Risk Register - unit dispatch"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - unit dispatch

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000386-unit-dispatch
**Version:** 0.70.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The longer `Done:` line breaks the resume match | low | medium | A test runs `resume-detect.mjs` on a classified line | open |
| R-002 | technical | The first table values pick a tier that is too low and cause rework | medium | low | The metrics report shows rework by class and tier. The two-failure retry on the primary tier stays. | open |
| R-003 | operational | An inline unit skips review that a subagent would give | low | low | The rule limits inline to agreed text and single-file content, and the check needs both markers | open |
| R-004 | operational | The step changes skills, so the driver stops for a setup rerun | high | low | The chart pre-approves the exact setup command | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The Agent tool accepts an `effort` value | The dispatch omits it and the table still records it | open |
