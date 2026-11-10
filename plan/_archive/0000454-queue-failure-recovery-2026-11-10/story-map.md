---
title: "Story Map - 0000454-queue-failure-recovery"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000454-queue-failure-recovery

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Rerun a failed queue run | Take back the stale version commit | US-001 | REQ-001 |
| Rerun a failed queue run | Leave an unchanged branch alone | US-001 | REQ-001 |
| Restart a step | Free the step branch after any run | US-002 | REQ-002 |
| Guard the recovery | Run the failure and restart path in a test | US-003 | REQ-003 |

## Gaps

None.
