---
title: "Story Map - 0000583-step-temp-cleanup-after-merge"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000583-step-temp-cleanup-after-merge

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Merge a step | The queue merges the step PR | US-001 | REQ-001 |
| Start a step | The driver sets a private TMPDIR and the sandbox | US-001 | REQ-001 |
| Merge a step | The driver removes the step worktree and its .t folder | US-001 | REQ-001 |
| Merge a step | The driver deletes nothing outside the repo | US-001 | REQ-003 |
| Run a suite | The suite makes a temp folder | US-002 | REQ-002 |
| Run a suite | A stop signal ends the suite | US-002 | REQ-002 |
| Run a suite | The suite removes its temp folder | US-002 | REQ-002 |
| Write scratch | The agent puts scratch under $TMPDIR | US-002 | REQ-004 |
| Clear leaked entries | Remove entries from earlier runs | none | gap: out of scope |

## Gaps

- Remove entries from earlier runs: out of scope. The brief limits the step to new leaks.
