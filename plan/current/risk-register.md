---
title: "Risk Register - Driver clears a dead lock"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.106.0"
---
# Risk Register - Driver clears a dead lock

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000495-driver-clears-dead-lock
**Version:** 0.106.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | Two drivers start together against one dead lock and both try to take it | low | medium | The take-over removes the file, then writes with `wx`. The loser gets `EEXIST` and refuses. | open |
| R-002 | operational | A lock that a driver is still writing reads as empty and the second driver takes it | low | medium | An empty or non-numeric lock refuses. Only a full decimal pid can read as dead. | open |
| R-003 | technical | `process.kill(pid, 0)` gives `EPERM` for a process of another user | low | low | The existing helper counts `EPERM` as alive, so the driver refuses. | accepted |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A reused pid reads as alive | The driver refuses and the coordinator removes the file, as today | open |
| A-002 | A pid that gives `ESRCH` names no driver | The driver takes a lock a live driver holds, and `wx` still lets one driver win | open |
