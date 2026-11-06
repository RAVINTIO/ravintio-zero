---
title: "Risk Register - Step titles and history shape"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Step titles and history shape

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000351-step-titles-and-history-shape
**Version:** 0.49.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | The shape check fails this initiative's activation commits (#109, #110) until the step 3 reshape runs. | high | low | CI runs the check only on a PR into `main`, after the reshape. | accepted |
| R-002 | technical | A title with special characters breaks matching. | low | medium | The script compares strings and builds no regular expression from a title. | open |
| R-003 | technical | The archived chart is missing at delivery, so the check can't read titles. | medium | medium | The script fails with a message that names the paths it tried. | open |
| R-004 | technical | Existing history tests (0000319) assume the old title form and fail. | high | low | P2 updates those tests in the same unit as the script. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The active chart holds the `Title` column. | The check can't read titles from this chart. | open |
