---
title: "Story Map - 0000378-merge-time-versioning"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000378-merge-time-versioning

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Prepare a step PR | Check the PR title against the chart | US-002 | REQ-002 |
| Merge a step | Set the version from the step's `Bump` | US-003 | REQ-003 |
| Merge a step | Check every version file after the bump | US-001 | REQ-001 |
| Merge a step | Merge and tag the merge commit | US-003 | REQ-003 |
| Merge a step | Record the merge in the chart | US-003 | REQ-003 |
| Deliver the initiative | Check history in merge order | US-004 | REQ-004 |
| Deliver the initiative | Reshape in merge order | US-004 | REQ-004 |
| Deliver the initiative | Fold admin commits that clear a conflict | US-005 | REQ-005 |
| Run steps at once | Drive the queue from the driver | none | gap: out of scope |

## Gaps

- Drive the queue from the driver: out of scope. Step 3 wires the driver, as the chart decisions say.
