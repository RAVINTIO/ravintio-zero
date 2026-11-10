---
title: "Requirement: REQ-001 - Shared-file resolver"
summary: "The merge queue resolves conflicts on shared files after the base merge."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Shared-file resolver

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000456-regenerate-shared-files-at-merge
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I want the queue to resolve conflicts on shared files, so that a step PR does not stop on them.

## Functional Requirements
- A new module `shared-files.mjs` exports `resolveSharedConflicts`. The queue calls it when `git merge` of the base reports conflicts.
- The module acts only on conflicted paths in a fixed allowlist. Any other conflicted path aborts the merge and stops the queue.
- `plan/backlog/.next-id` and `docs/adr/.next-id` take the higher number.
- The module regenerates `plan/backlog/index.md` with `backlog-index.mjs` after the other files resolve.
- `docs/decisions-index.md` and `docs/architecture-overview.md` resolve each `Last updated:` conflict to the step side. They keep the table rows that either side added and drop exact duplicate lines.
- A hunk that the module cannot read aborts the merge and stops the queue.
- The queue prints one `resolved:` line per file, then commits the merge with its existing subject.

## Acceptance Criteria
- [ ] AC-1: Counter files
  - Given the base and the PR branch each raised `plan/backlog/.next-id`
  - When the queue merges the base
  - Then the file holds the higher number and the merge commits
- [ ] AC-2: Index files
  - Given a conflict in `plan/backlog/index.md` and in `docs/decisions-index.md`
  - When the queue merges the base
  - Then the backlog index matches a fresh `backlog-index.mjs` run
  - And the decisions index keeps both sides' added rows with the step's `Last updated:` line
- [ ] AC-3: Other conflicts
  - Given a conflict in a file outside the allowlist
  - When the queue merges the base
  - Then the merge aborts and the queue stops with a `merge-queue:` error

## Dependencies
- `merge-queue.mjs` and `backlog-index.mjs`
