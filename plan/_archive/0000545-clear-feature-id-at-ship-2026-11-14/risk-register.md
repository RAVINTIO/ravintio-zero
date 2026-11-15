---
title: "Risk Register - 0000545-clear-feature-id-at-ship"
summary: "Technical risks and assumptions for the feature id fix."
status: "active"
version: "0.1.0"
---
# Risk Register - 0000545-clear-feature-id-at-ship

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000545-clear-feature-id-at-ship
**Version:** 0.115.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|-------------|------------|--------|-----------|--------|
| R-001 | technical | An existing test pins the Step 8 text and fails after the edit. | medium | low | Update the pin in the same step and log a Rework line. | open |
| R-002 | operational | Deleting the file leaves resume detection with no id file. | low | low | Resume detection already handles a missing file after ship. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A step session writes its own `plan/.feature-id` at P0 when none exists. | A fresh step reports a missing id file. | open |
