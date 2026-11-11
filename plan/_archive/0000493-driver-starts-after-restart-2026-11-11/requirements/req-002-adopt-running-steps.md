---
title: "Requirement: REQ-002 - Adopt running steps"
summary: "The successor tracks steps that the old driver still runs and queues each ready step once."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Adopt running steps

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000493-driver-starts-after-restart
**Source:** US-002
**Priority:** must-have

## User Story

As the coordinator, I want the new driver to adopt steps that the old driver still runs. No step then starts twice.

## Functional Requirements
- The successor checks that the lock file holds its own pid. If it does not, the successor stops with a `Blocked:` line.
- The successor reads the control folders. A step with `ready` goes to the queue. A step with `running` and a live pid that is not its own counts as adopted.
- An adopted step counts against the concurrency cap and starts no session.
- The successor polls each adopted step. A `ready` file moves the step to the queue. A `stopped` file stops new starts.
- A step whose `running` pid is dead restarts its session in the existing worktree.
- Only the lock holder runs the queue, so one PR never goes through the queue twice.

## Acceptance Criteria
- [ ] AC-1: No duplicate session
  - Given the old driver still supervises step 2
  - When the successor reads the control folders
  - Then it starts no second session for step 2 and counts step 2 against the cap
- [ ] AC-2: Ready step queued once
  - Given an adopted step writes `ready`
  - When the successor polls the step
  - Then the successor queues the PR once and the old driver queues nothing
- [ ] AC-3: Dead supervisor
  - Given a `running` file names a dead pid and no `ready` file exists
  - When the successor reads the control folders
  - Then it restarts that step's session in the existing worktree

## Dependencies
- REQ-001 spawns the successor.
