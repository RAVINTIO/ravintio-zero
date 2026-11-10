---
title: "Requirement: REQ-002 - driver prompt"
summary: "The driver start and continue prompts name the queue items that name the step."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - driver prompt

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000444-step-reads-its-queue-items
**Source:** US-002
**Priority:** must-have

## User Story

As the driver, I name each queue item in the step start prompt, so that the session sees them first.

## Functional Requirements
- The start prompt stays `Run initiative step {n}` when no item names the step.
- If items name the step, the prompt adds one sentence that lists their folder names and the queue path.
- The continue prompt adds the same sentence.
- The driver prints only folder names that match `^[A-Za-z0-9._-]{1,80}$`. It never prints item content.
- Both the serial path and the concurrent path read the queue in the main root.

## Acceptance Criteria
- [ ] AC-1: no item
  - Given an empty queue
  - When the driver starts the step
  - Then the prompt is exactly `Run initiative step 1`
- [ ] AC-2: named item
  - Given an item that names step 1
  - When the driver starts the step
  - Then the prompt lists its folder name
- [ ] AC-3: hostile name
  - Given an item folder whose name holds a space or a newline
  - When the driver starts the step
  - Then the prompt omits that name

## Dependencies
- REQ-001
