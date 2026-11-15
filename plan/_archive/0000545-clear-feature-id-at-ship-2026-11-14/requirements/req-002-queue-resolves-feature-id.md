---
title: "Requirement: REQ-002 - Queue resolves the feature id file"
summary: "shared-files.mjs resolves a base-merge conflict on plan/.feature-id."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Queue resolves the feature id file

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000545-clear-feature-id-at-ship
**Source:** US-002
**Priority:** must-have

## User Story

As the merge queue, I resolve a base-merge conflict on `plan/.feature-id`, so that a stale id never stops the queue.

## Functional Requirements
- `shared-files.mjs` lists `plan/.feature-id` as a shared file.
- If the PR branch deleted the file, the resolution keeps it deleted.
- If the PR branch holds the file, the resolution keeps the PR branch text.

## Acceptance Criteria
- [ ] AC-1: A deleted file stays deleted
  - Given the PR branch deleted `plan/.feature-id` and the base changed it
  - When `resolveSharedConflicts` runs
  - Then the file is absent and the call lists it as resolved
- [ ] AC-2: A held file keeps the PR text
  - Given both sides changed `plan/.feature-id`
  - When `resolveSharedConflicts` runs
  - Then the file holds the PR branch text

## Dependencies
- None.
