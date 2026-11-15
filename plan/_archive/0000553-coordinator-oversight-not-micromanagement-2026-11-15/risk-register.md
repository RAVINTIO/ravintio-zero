---
title: "Risk Register - 0000553-coordinator-oversight-not-micromanagement"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - 0000553-coordinator-oversight-not-micromanagement

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000553-coordinator-oversight-not-micromanagement
**Version:** 0.119.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The skill line cap of 120 leaves 2 spare lines. | medium | low | The unit replaces text and adds no more than 2 net lines. | open |
| R-002 | operational | The coordinator reports less often and the human sees a stale step later. | low | low | A phase event, a block, and a stop still reach the human at once. | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Stops print their own `Blocked:` and `Stopping:` lines. | The coordinator misses a stop. | open |
