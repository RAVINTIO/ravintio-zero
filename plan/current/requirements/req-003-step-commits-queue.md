---
title: "Requirement: REQ-003 - The step commits the items that name it"
summary: "A step session writes each queued item that names its step to the destination and commits it before P4 raises the PR."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - The step commits the items that name it

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000352-coordinator-admin-in-step-prs
**Source:** US-002
**Priority:** must-have

## User Story

As a step session, I commit the queued items that name my step before P4 raises the PR, so that the squash carries them.

## Functional Requirements
- `roadmap-standards.md` I-C Run says a step reads `plan/.initiative-queue/` at P0 and again before P4, and acts only on items whose `**Step:**` names its number.
- For each such item, the step writes the content to the destination, stages the destination by explicit path, and commits it on its feature branch before P4 raises the PR.
- The step never moves, renames, or deletes the queue folder or an item. The coordinator clears the items after the step merges.
- I-D Advance step 2 says the PR is raised only after the queue commits.
- The ship skill initiative section and the orchestrator backlog pickup line point to I-C Run for the rule.

## Acceptance Criteria
- [ ] AC-1: step reads and commits
  - Given `roadmap-standards.md` I-C Run
  - When a reader looks for what a step does with the queue
  - Then it says to commit each item that names the step before P4 raises the PR
- [ ] AC-2: queue stays in place
  - Given the same text
  - When a reader looks for queue cleanup
  - Then the step never moves, renames, or deletes the queue and the coordinator clears the items
- [ ] AC-3: ship and orchestrator point to the rule
  - Given the ship skill and the orchestrator backlog pickup reference
  - When a reader looks for queue handling
  - Then each names I-C Run

## Dependencies
- REQ-002 defines the item format.
