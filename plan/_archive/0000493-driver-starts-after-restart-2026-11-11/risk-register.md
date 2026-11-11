---
title: "Risk Register - Driver keeps starting steps after a Restart"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - Driver keeps starting steps after a Restart

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000493-driver-starts-after-restart
**Version:** 0.105.0
**Overall Risk Level:** medium

> Every entry is specific to this feature.

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The successor starts a second session for a step that the old driver still runs. | low | high | The successor adopts any step whose `running` pid is alive. A scheduler test counts session starts per step. | open |
| R-002 | technical | Both drivers run the merge queue and merge one PR twice. | low | high | Only the lock holder runs the queue. The old driver never queues after the handoff. A test counts queue runs per PR. | open |
| R-003 | operational | The old driver dies mid-handoff and leaves sessions with no supervisor. | medium | medium | The successor restarts a step whose `running` pid is dead, in the existing worktree. | open |
| R-004 | operational | The coordinator starts a second driver after a handoff line and hits the lock. | medium | low | The initiative skill and the standards say a handoff line needs a new watcher only. The lock check stops a second driver. | open |
| R-005 | technical | The spawned driver runs old code because the root did not fast-forward. | medium | medium | The driver hands off only after a clean fast-forward. Otherwise it keeps the existing stop. | open |
| R-006 | security | A stop line in the `stopped` file carries text that a later reader runs. | low | medium | The successor reads the file as data, cuts it to 500 characters, and passes it to no shell. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The main root sits on the initiative branch. | The fast-forward fails and the driver keeps the existing stop. | open |
| A-002 | The `running` file holds the pid of the driver that supervises the session. | The successor starts a duplicate session. | open |
| A-003 | Inherited output handles stay valid after the old driver exits. | The successor loses its output. | open |
