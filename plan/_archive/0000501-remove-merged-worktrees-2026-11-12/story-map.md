---
title: "Story Map - 0000501-remove-merged-worktrees"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000501-remove-merged-worktrees

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Start the driver | Find each chart step with status `merged` that still has a worktree | US-001 | REQ-001 |
| Start the driver | Remove the worktree when it is clean, pushed, and has no live session | US-001 | REQ-001 |
| Start the driver | Keep a worktree with uncommitted files and name them | US-002 | REQ-002 |
| Start the driver | Keep a worktree when git cannot inspect it | US-002 | REQ-002 |
| Start the driver | Keep a worktree whose head is not on its origin branch | US-002 | REQ-003 |
| Start the driver | Keep a worktree with a live session | US-002 | REQ-003 |
| Read the docs | Find the rule in the driver comment and the standards | US-001, US-002 | REQ-004 |
| Run the driver | Sweep after every merge | none | gap: out of scope |

## Gaps

- Sweep after every merge: the queue already removes the worktree of the step it merges. The scope lists a later sweep as out of scope.
