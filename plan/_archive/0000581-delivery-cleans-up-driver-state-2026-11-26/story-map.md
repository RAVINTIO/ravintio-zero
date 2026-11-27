---
title: "Story Map - 0000581-delivery-cleans-up-driver-state"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000581-delivery-cleans-up-driver-state

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run the cleanup | Refuse while a driver holds the lock | US-001 | REQ-001 |
| Run the cleanup | Move the logs and control folders to the git folder | US-001 | REQ-002 |
| Run the cleanup | Remove the worktrees and report the queue | US-001 | REQ-003 |
| Start the next initiative | Read zero merged, ready, and running steps | US-001 | REQ-004 |
| Read the delivery text | Find the cleanup step and the report item | US-002 | REQ-005 |
| Recover from a stopped cleanup | Rerun and move what remains | US-001 | REQ-002 |

## Gaps

- Clean up an initiative that has not merged: gap: out of scope. The brief limits the cleanup to a delivered initiative.
