---
title: "Story Map - 0000497-keep-worktree-entries"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000497-keep-worktree-entries

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Merge a step | List untracked files under `plan/backlog/` | US-001 | REQ-001 |
| Merge a step | Keep the worktree and stop the queue when the list is not empty | US-001 | REQ-001 |
| Merge a step | Remove a worktree with an empty list | US-002 | REQ-002 |
| Merge a step | Keep the worktree when git cannot list the files | US-002 | REQ-002 |
| File an entry | Commit the entry by explicit path before the PR | US-003 | REQ-003 |
| Merge a step | Move the entry to the main tree's queue | none | gap: out of scope |

## Gaps

- Move the entry to the main tree's queue: the entry allows a refusal instead. The scope lists the move as out of scope.
