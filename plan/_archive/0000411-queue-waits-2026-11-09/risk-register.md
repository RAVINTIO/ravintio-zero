---
title: "Risk Register - the merge queue waits for GitHub before it merges"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - the merge queue waits for GitHub before it merges

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000411-queue-waits
**Version:** 0.72.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | GitHub reports `BLOCKED` for a reason other than checks, so the queue waits to its limit | low | medium | The queue stops with a named error after 30 minutes | open |
| R-002 | technical | A running driver keeps the old script | medium | low | The coordinator restarts the driver after the merge | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `gh pr view` reports the mergeability that `gh pr merge` uses | The retry covers the gap | open |
