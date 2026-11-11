---
title: "Risk Register - Coordinator status view"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Coordinator status view

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000450-coordinator-status-view
**Version:** 0.95.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A new driver line breaks a test that matches driver output exactly. | medium | low | U-3 runs the driver suites and updates them in the same unit. | open |
| R-002 | operational | A changed driver or watcher file triggers the restart stop after merge. | high | low | The coordinator restarts the driver and watcher as the standards describe. | open |
| R-003 | technical | The status script shows a stop that the human already cleared outside the logs. | low | low | The chart status and `Resolved:` lines clear it. A remaining case needs a manual note. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The chart `Status` column is the source of truth for merged steps. | A merged step shows as live. | open |
| A-002 | The queue output reaches the step log through the driver. | The watcher misses the queue event. | open |
