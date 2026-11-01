---
title: "Risk Register - driver setup stop"
summary: "Risks for the driver setup stop."
status: "active"
version: "0.41.0"
---
# Risk Register - driver setup stop

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000313-driver-setup-stop
**Version:** 0.41.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | The initiative skill is under `ravintio-zero/skills/`, so every skill change triggers both stops. | high | low | The combined line names both and the skill handles it in one pass. | accepted |
| R-002 | technical | A long file list passes the 500-character line limit and the driver cuts it. | medium | low | The list names 5 files, then `and {k} more`. | open |
| R-003 | security | The skill reruns a setup command that differs from the approved one. | low | high | The skill runs only the exact command a `Confirmation:` row names, and a test checks the rule text. | open |
| R-004 | technical | Existing test `test-0000250-req-002` AC-3 changes a skill file and expects no stop. | high | low | Unit U1 changes that case to a test-only path. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Step 1 ends with a `Restart:` line from the old driver. | The combined line appears one step early. | open |
