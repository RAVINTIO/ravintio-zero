---
title: "Requirement: REQ-001 - Regenerate shared files after every base merge"
summary: "The queue regenerates shared files after every base merge and commits any change before the push."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Regenerate shared files after every base merge

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000481-regenerate-after-every-merge
**Source:** US-001
**Priority:** must-have

## User Story

As the merge queue, I regenerate shared files after every base merge, so that CI does not fail on a stale file.

## Functional Requirements
- After the base merge, clean or resolved, the queue rebuilds `plan/backlog/index.md` with `backlog-index.mjs`.
- The queue raises `plan/backlog/.next-id` and `docs/adr/.next-id` to the higher value of the two merge parents if either is lower.
- If any file changes, the queue commits it by path with the subject `{first 7 digits of Feature id}: Regenerate shared files` before it pushes.
- If nothing changes, the queue adds no commit.
- The queue prints `regenerated: {path}` for each changed file.

## Acceptance Criteria
- [ ] AC-1: Stale index after a clean merge
  - Given a clean base merge that leaves `plan/backlog/index.md` stale
  - When the queue runs the regeneration
  - Then it commits the rebuilt index and prints `regenerated: plan/backlog/index.md`
- [ ] AC-2: Nothing to change
  - Given a base merge after which every shared file is current
  - When the queue runs the regeneration
  - Then it adds no commit
- [ ] AC-3: Counters never fall
  - Given a merge that leaves a counter below the higher parent value
  - When the queue runs the regeneration
  - Then it raises the counter and commits it

## Dependencies
- `backlog-index.mjs`, `shared-files.mjs`
