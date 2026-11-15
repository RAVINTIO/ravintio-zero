---
title: "Requirement: REQ-002 - Driver pause request"
summary: "The driver stops starting steps and ends at phase boundaries on a pause request."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Driver pause request

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000555-initiative-pause-reaches-every-step
**Source:** US-001
**Priority:** must-have

## User Story

As the human on the loop, I see the driver start no step. It waits for each session to reach a phase end and then releases the lock.

## Functional Requirements
- `initiative-pause.mjs request --root {dir}` writes `plan/.initiative-control/pause`.
- While that file exists, the driver starts no step and takes no new item into the merge queue. A merge in progress finishes.
- The driver stops each running session when its build log gains a `Complete: P{n}` line, or after the step writes `ready` or a block.
- The driver then runs `initiative-pause.mjs write --merged {list}`. The list comes from the initiative branch, because the chart in the root can lag.
- The driver releases the lock, prints `I-C Run: Paused: {n} steps merged, {k} steps hold a pause record`, and exits 0.
- At the next start the driver reads the initiative pause record and prints `I-C Run: Resuming: initiative pause record read`.
- It then removes the request and the initiative record, and starts each step in its worktree.

## Acceptance Criteria
- [ ] AC-1: No new starts
  - Given a pause request and a pending step
  - When the driver loop runs
  - Then the driver starts no session for the pending step
- [ ] AC-2: Phase boundary stop
  - Given a running step whose build log gains a `Complete:` phase line
  - When the driver sees the line
  - Then it stops the session and writes the records
- [ ] AC-3: Resume
  - Given a pause record and no request
  - When the driver starts
  - Then it prints the resume line and starts the steps

## Dependencies
- REQ-001.
