---
title: "Risk Register - short subject for the queue's base merge"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - short subject for the queue's base merge

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000405-queue-merge-subject
**Version:** 0.62.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | A running driver keeps the old script after the fix merges | medium | low | The coordinator restarts the driver after the merge | open |
| R-002 | technical | A test world without a hook misses a future long subject | low | medium | The new test installs a blocking `commit-msg` hook | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Every `Feature id` starts with 7 digits | The subject has no id prefix | open |
