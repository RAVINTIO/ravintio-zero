---
title: "Risk Register - Planned restart exits with its own code"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.108.0"
---
# Risk Register - Planned restart exits with its own code

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000503-planned-restart-exit-code
**Version:** 0.108.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A failure exits 75 by mistake | low | medium | A later stop line drops the planned flag. A test pins it. | open |
| R-002 | technical | A fixture still expects exit 1 for a restart line | high | low | The step updates the four fixtures. The full suite finds any other. | open |
| R-003 | operational | A script outside the pack reads exit 1 as the restart signal | low | low | The stop line text stays the same. | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Code 75 means no other driver exit today | The coordinator reads a second cause as a restart | open |
| A-002 | A restart hit with a later failure reads as a failure | The coordinator reads the stop line either way | open |
