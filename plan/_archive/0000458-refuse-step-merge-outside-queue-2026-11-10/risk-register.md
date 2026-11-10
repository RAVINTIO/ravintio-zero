---
title: "Risk Register - refuse a step merge outside the queue"
summary: "Technical risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - refuse a step merge outside the queue

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000458-refuse-step-merge-outside-queue
**Version:** 0.80.1
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The block stops a no-driver step that runs the plain merge line | low | medium | That path leaves the variable unset, and I-D Advance runs `merge-queue.mjs` there | open |
| R-002 | technical | The guard misses the variable because the hook environment differs | low | medium | The guard fails to the old rules, which the queue and the PR base check still cover. A test sets the variable | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Claude Code passes its environment to hook processes | The guard allows the merge as it does today | open |
