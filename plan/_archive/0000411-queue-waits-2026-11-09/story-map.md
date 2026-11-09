---
title: "Story Map - 0000411-queue-waits"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000411-queue-waits

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Merge a ready step | Wait for GitHub to see the pushed head | US-001 | REQ-001 |
| Merge a ready step | Wait for CI and mergeability before the merge | US-001 | REQ-001 |
| Merge a ready step | Retry a transient merge failure once | US-001 | REQ-001 |

## Gaps

None.
