---
title: "Story Map - 0000472-ci-duration-metric"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000472-ci-duration-metric

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Record CI duration | Ship waits for CI and reads the run duration | US-001 | REQ-002 |
| Record CI duration | Ship appends the `CI duration:` marker | US-001 | REQ-002 |
| Read the report | The script finds the longest marker | US-001 | REQ-001 |
| Read the report | The script compares it with the threshold | US-001 | REQ-001 |
| Read the report | A standard names the target | US-001 | REQ-002 |

## Gaps

None.
