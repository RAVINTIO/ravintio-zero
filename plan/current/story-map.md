---
title: "Story Map - 0000379-parallel-steps-on-worktrees"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000379-parallel-steps-on-worktrees

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Chart an initiative | Give each step a lane, an `After` list, and set `**Concurrency:**` | US-001 | REQ-001 |
| Run steps | Pick the steps that may start | US-002 | REQ-002 |
| Run steps | Start each step in its own worktree with its own log | US-002 | REQ-003 |
| Merge steps | End a step at ready and hand its PR to the queue | US-003 | REQ-004 |
| Handle a stop | Stop new starts and report every step | US-004 | REQ-005 |
| Watch a run | Report each running step | US-005 | REQ-006 |
| Work by hand | Keep human sessions on a `feat/` branch in the main tree | US-006 | REQ-007 |

## Gaps

- None.
