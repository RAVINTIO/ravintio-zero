---
title: "Feature Brief - Coordinator branches regenerate shared files"
summary: "One command brings the initiative branch into a coordinator branch and regenerates the shared files."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Coordinator branches regenerate shared files

**Feature ID:** 0000505-coordinator-branch-regenerate

## Business Goal

On 2026-11-11 the coordinator merged the initiative branch into the branch for steps 42 to 50. The merge conflicted in `plan/backlog/index.md`, the same generated-file conflict the merge queue meets. Coordinator branches have no command that resolves generated files after a merge. The coordinator needs one command that does the merge and leaves the shared files current.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Coordinator base merge command | As the coordinator, I run one command that merges the initiative branch into my branch and regenerates the shared files, so that the merge never leaves a stale index or counter. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | `coordinator-merge.mjs` reuses `shared-files.mjs` |

### Data Ownership

No data store changes.

## Scope Boundaries

### In Scope
- A script `coordinator-merge.mjs` that merges a base ref into the current branch.
- It resolves conflicts on allowlisted shared files, regenerates them, and commits the result.
- It refuses, and aborts the merge, when a conflict touches any other file.
- Tests, docs, and the roadmap standards text.

### Out of Scope
- New shared files. The allowlist stays as it is.
- Any change to the merge queue.

### Deferred
- None.

## Constraints and Assumptions

### Constraints
- Git calls take argument arrays. The script treats file text as data.
- It never force-pushes and never pushes.

### Assumptions
- `regenerateSharedFiles` and `resolveSharedConflicts` in `shared-files.mjs` cover every file the command needs.

## Acceptance Criteria

- [ ] After a clean merge that leaves `plan/backlog/index.md` stale, the command commits a regenerated index.
- [ ] After a merge that conflicts only on shared files, the command resolves them and commits the merge.
- [ ] After a merge that conflicts on any other file, the command aborts the merge, names the files, and exits 1.
- [ ] A counter never falls below the higher parent value after the command.
