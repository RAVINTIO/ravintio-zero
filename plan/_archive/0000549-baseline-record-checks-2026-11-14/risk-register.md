---
title: "Risk Register - 0000549-baseline-record-checks"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - 0000549-baseline-record-checks

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000549-baseline-record-checks
**Version:** 0.115.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A run that starts with no baseline file now exits 1 at P3. A step that skips the P0 record call stops there. | medium | medium | The failure message names the cause. P0 start action 15 already tells the agent to record the baseline. | accepted |
| R-002 | technical | A change to the `run-tests.sh` totals line makes `record` refuse good output. | low | medium | The suite fixtures pin the `Feature suites:` line. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Every finished `run-tests.sh` run prints a `Feature suites:` line. | `record` refuses good output. | open |
