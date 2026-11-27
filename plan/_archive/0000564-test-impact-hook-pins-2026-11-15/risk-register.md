---
title: "Risk Register - Test impact scan names hook pins"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Test impact scan names hook pins

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000564-test-impact-hook-pins
**Version:** 0.122.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A suite pins the cause list and fails when a cause joins it. | low | low | Run the scan suites and update a pin in the same unit, with a `Rework:` line. | open |
| R-002 | technical | The two pack trees drift apart. | medium | medium | Run `sync-installed.mjs` and its `--check` flag before commit. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The plan skill already has a Pack Index row for the reference file. | The step adds the row. | open |
