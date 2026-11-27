---
title: "Story Map - 0000546-queue-failure-leaves-dirty-files"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000546-queue-failure-leaves-dirty-files

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run the queue | The run writes the version files and the chart | US-001 | REQ-001 |
| Run the queue | The commit or the push fails | US-001 | REQ-001 |
| Run the queue | The queue restores the files it wrote | US-001 | REQ-001 |
| Run the queue | The next run starts on a clean tree | US-001 | REQ-001 |

## Gaps

- None.
