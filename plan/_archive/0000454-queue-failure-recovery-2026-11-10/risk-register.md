---
title: "Risk Register - queue failure recovery"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - queue failure recovery

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000454-queue-failure-recovery
**Version:** 0.78.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A revert conflicts with a later change to the same lines | medium | low | The queue aborts the revert, prints the git error, and leaves the branch as it was | open |
| R-002 | technical | The detach fails on a dirty tree | low | low | The queue ignores the failure, and the next run reports the dirty tree | open |
| R-003 | operational | Steps 32, 33, and 36 edit the same file and conflict with this step | medium | low | Each step merges the initiative branch first, and the lanes order them | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The queue worktree belongs to the queue | A detach drops a branch that a person had open there | open |
| A-002 | A set-version commit subject matches `chore({id7}): set version {v} for step {n}` | The queue finds no commit to revert and the conflict returns | open |
