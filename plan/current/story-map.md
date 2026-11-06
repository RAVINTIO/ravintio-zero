---
title: "Story Map - 0000352-coordinator-admin-in-step-prs"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000352-coordinator-admin-in-step-prs

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run | Queue admin that aligns with a running step and name that step | US-001 | REQ-002 |
| Run | Land admin that fits no step through a `chore/` PR | US-003 | REQ-002 |
| Run | Commit the queued items that name the step before P4 raises the PR | US-002 | REQ-003 |
| Run | Reserve an id without a direct commit on the initiative branch | US-004 | REQ-001, REQ-005 |
| Advance | Delete the coordinator branch when the squash merges | US-005 | REQ-004 |

## Gaps

- None.
