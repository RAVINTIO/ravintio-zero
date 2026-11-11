---
title: "Story Map - 0000483-mergeability-before-ci-wait"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000483-mergeability-before-ci-wait

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Wait for CI in the queue | The queue polls checks and sees none | US-001 | REQ-001 |
| Wait for CI in the queue | The queue reads `mergeable` and sees `CONFLICTING` | US-001 | REQ-001 |
| Wait for CI in the queue | The queue stops with a named error | US-001 | REQ-001 |
| Wait for CI in the queue | No check appears after the set time and the queue stops | US-001 | REQ-001 |
| Wait for CI in a step | The step reads `mergeable` before the poll | US-002 | REQ-002 |
| Wait for CI in a step | The step merges the initiative branch into a conflicting PR | US-002 | REQ-002 |

## Gaps

None.
