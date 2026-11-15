---
title: "Risk Register - Test impact scan covers size caps and frozen lines"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Test impact scan covers size caps and frozen lines

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000567-test-impact-size-caps-and-frozen-lines
**Version:** 0.125.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A suite pins the cause text and fails when a cause changes. | low | low | Run the scan suites and update a pin in the same unit, with a `Rework:` line. | open |
| R-002 | technical | The two pack trees drift apart. | medium | medium | Run `sync-installed.mjs` and its `--check` flag before commit. | open |
| R-003 | technical | The scan grows past 20 lines. | low | low | The edit adds words to two existing lines and no new line. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Entry 0000526 names a 3800 byte boot cap. The suite holds 4000 now. | None, because the cause names the suite and not the number. | open |
