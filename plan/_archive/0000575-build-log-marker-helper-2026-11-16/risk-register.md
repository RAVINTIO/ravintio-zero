---
title: "Risk Register - Build log marker helper"
summary: "Risks and assumptions for the marker helper."
status: "active"
version: "0.1.0"
---
# Risk Register - Build log marker helper

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000575-build-log-marker-helper
**Version:** 0.135.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The script writes a line that `build-log-check.mjs` rejects | low | medium | A test runs the checker on a log the script wrote | open |
| R-002 | technical | A suite pins the implement skill text | medium | low | The Test impact scan lists the pins | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The marker forms in the two standards stay as they are | The script writes a line the checks reject | open |
