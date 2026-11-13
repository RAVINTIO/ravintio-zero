---
title: "Requirement: REQ-002 - Renumber a colliding backlog entry and call the module from the queue"
summary: "The module renumbers a PR backlog entry whose id a base entry also holds, and the queue runs it after the base merge."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Renumber a colliding backlog entry and call the module from the queue

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000485-adr-number-collision
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I merge parallel steps that filed entries under one id, so that each entry keeps a unique id.

## Functional Requirements
- A backlog entry collides when the PR added `plan/backlog/{id}-{slug}/` since the merge base, and the merged tree holds another folder with the same seven-digit `id`.
- Each colliding entry gets the next id above the highest id in `plan/backlog/` and the counter. The module renames the folder with `git mv`.
- The module rewrites the old id in the entry's title and heading, and in files the PR added or changed since the merge base.
- The module raises `plan/backlog/.next-id` and rebuilds `plan/backlog/index.md` with `backlog-index.mjs`.
- `merge-queue.mjs` runs the module right after the base merge, in the clean path and after `resolveSharedConflicts`.
- If the module changed files, the queue commits them by path with the subject `{first 7 digits of Feature id}: Renumber colliding ids`. It prints `renumbered: {kind} {from} -> {to}` for each change, and pushes with the rest of the merge.
- If the module finds nothing, the queue adds no commit and prints no line.

## Acceptance Criteria
- [ ] AC-1: the module renumbers a colliding entry
  - Given the PR added `0000479-a/` and the base added `0000479-b/`
  - When the module runs on the merged tree
  - Then the PR folder becomes the next free id, the base folder stays, and the index lists both
- [ ] AC-2: the queue renumbers after a clean merge
  - Given two step PRs reserved ADR 0301 and the first has merged
  - When the queue runs the second
  - Then it prints `renumbered: adr 0301 -> 0302`, commits, and merges
- [ ] AC-3: the queue renumbers after a shared-file resolution
  - Given the same two PRs also conflict on the counter
  - When the queue runs the second
  - Then it prints a `resolved:` line and a `renumbered:` line, and merges

## Dependencies
- REQ-001 (the module and its ADR logic)
