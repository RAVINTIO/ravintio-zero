---
title: "Story Map - 0000557-self-matching-pgrep-wait"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000557-self-matching-pgrep-wait

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run a suite | The session starts the suite in the background | US-001 | REQ-001 |
| Run a suite | The session waits on an end marker or a process id | US-001 | REQ-001 |
| Run a suite | A skill with a `pgrep -f` wait fails the test | US-001 | REQ-001 |

## Gaps

- None.
