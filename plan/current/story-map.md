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
| Merge a step | The driver removes the step's temp paths and worktrees | US-001 | REQ-001 |
| Merge a step | A restarted driver sweeps a step that merged earlier | US-001 | REQ-001 |
| Run a suite | The suite makes a temp folder | US-002 | REQ-002 |
| Run a suite | A stop signal ends the suite | US-002 | REQ-002 |
| Run a suite | The suite removes its temp folder | US-002 | REQ-002 |
| Clear leaked entries | Remove entries from earlier runs | none | gap: out of scope |

## Gaps

- Remove entries from earlier runs: out of scope. The brief limits the step to new leaks.
