---
title: "Risk Register - Require unit reports"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Require unit reports

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000573-require-unit-reports
**Version:** 0.115.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A test pins text near the new rule and fails. | low | low | Run the full suite. Update the pin in the same step and log a `Rework:` line. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The tests live in `ravintio-zero/tests/` only. | The test needs a second copy. | open |
