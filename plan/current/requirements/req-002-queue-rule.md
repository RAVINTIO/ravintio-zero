---
title: "Requirement: REQ-002 - Queue rule for aligned and unaligned admin"
summary: "Standards and the initiative skill route admin work into the step PR or a chore PR."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Queue rule for aligned and unaligned admin

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000352-coordinator-admin-in-step-prs
**Source:** US-001, US-003
**Priority:** must-have

## User Story

As a coordinator, I queue admin work that aligns with a running step and name that step, so that the step commits it in its own PR. As a coordinator, I land admin that fits no step through a `chore/` PR as it happens, so that later steps run on current admin.

## Functional Requirements
- `roadmap-standards.md` defines a queue item as a folder in `plan/.initiative-queue/` whose `item.md` holds `**Step:** {n}` and `**Destination:** {repo path}`. The other files in the folder are the content to write at the destination.
- The standards define aligned admin: step N caused it or it serves step N. They list the examples from entry 0000345.
- The standards say that, while the driver runs, the coordinator queues aligned admin with the step named, and queues the instruction or entry for the next pending step when step N is already running.
- The standards say that admin which fits no step lands through a `chore/` PR as it happens, while the driver is stopped.
- The initiative skill `## Backlog queue` states the same rules in no more than the lines the cap allows.
- The `## Coordinator PRs` timing bullet and the `#### Sessions and ack files` queue bullet drop the old "after the step merges, land through a coordinator PR" wording for aligned admin.

## Acceptance Criteria
- [ ] AC-1: item contract
  - Given `roadmap-standards.md`
  - When a reader looks for the queue item format
  - Then it names `item.md`, `**Step:**`, and `**Destination:**`
- [ ] AC-2: routes
  - Given the standards and the initiative skill
  - When a reader looks for where aligned and unaligned admin lands
  - Then aligned admin goes in the step PR and unaligned admin goes through a `chore/` PR
- [ ] AC-3: skill cap
  - Given the initiative skill after the edit
  - When its lines are counted
  - Then it holds fewer than 120 lines

## Dependencies
- REQ-003 states the step side of the contract.
