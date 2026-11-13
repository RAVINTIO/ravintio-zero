---
title: "Requirement: REQ-001 - Coordinator merge command"
summary: "One command merges the initiative branch into a coordinator branch and regenerates the shared files."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Coordinator merge command

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000505-coordinator-branch-regenerate
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I run one command to merge the initiative branch into my branch. It regenerates the shared files, so no stale index or counter remains.

## Functional Requirements
- `node ravintio-zero/scripts/coordinator-merge.mjs --base {ref}` merges `{ref}` into the current branch.
- If the merge conflicts only on shared files, the command resolves them with `resolveSharedConflicts` and commits the merge.
- After every merge, clean or resolved, the command calls `regenerateSharedFiles`. It commits any change and prints `regenerated: {path}`.
- If a conflict touches any other file, the command aborts the merge, names the files, and exits 1. The branch stays as it was.
- If the working tree has uncommitted changes, the command exits 1 before it merges.
- If the branch already holds `{ref}`, the command adds no commit and still regenerates.
- The command never pushes.

## Acceptance Criteria
- [ ] AC-1: Stale index after a clean merge
  - Given a clean merge of the base that leaves `plan/backlog/index.md` stale
  - When the command runs
  - Then it commits a regenerated index and prints `regenerated: plan/backlog/index.md`
- [ ] AC-2: Conflict on shared files
  - Given a merge that conflicts only in `plan/backlog/index.md` and a counter
  - When the command runs
  - Then it resolves both, commits the merge, and prints a `resolved:` line for each
- [ ] AC-3: Conflict on any other file
  - Given a merge that conflicts in a file outside the allowlist
  - When the command runs
  - Then it aborts the merge, names the file, and exits 1

## Dependencies
- `shared-files.mjs`, `backlog-index.mjs`
