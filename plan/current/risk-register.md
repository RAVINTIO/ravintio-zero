---
title: "Risk Register - 0000583-step-temp-cleanup-after-merge"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - 0000583-step-temp-cleanup-after-merge

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000583-step-temp-cleanup-after-merge
**Version:** 0.146.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | The pattern `step{n}` removes a path of another step or of a person | low | high | The lookahead `(?![0-9])` and a test for `step20`. The test sets `RAVINTIO_STEP_TEMP_DIRS` so it never touches the real temp folder. | open |
| R-002 | technical | A suite pins the driver header or the standards text that this step edits | medium | low | The test impact scan lists each pin. The unit updates it and logs a `Rework:` line. | open |
| R-003 | technical | A signal trap changes a suite's exit code | low | medium | The trap exits with 143 or 130 only on a signal. A normal exit keeps its code. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Step temp paths start with `step{n}` in the temp folder | The driver leaves a differently named path behind | open |
