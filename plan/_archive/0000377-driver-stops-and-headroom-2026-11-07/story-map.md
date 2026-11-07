---
title: "Story Map - 0000377-driver-stops-and-headroom"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000377-driver-stops-and-headroom

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Maintain the pack | Free byte headroom in the orchestrator skill | US-001 | REQ-001 |
| Run an initiative | Stop on an open Question line | US-002 | REQ-002 |
| Run an initiative | Report an open Question line in the watcher | US-002 | REQ-002 |
| Run an initiative | Check for a Setup stop after the last step | US-003 | REQ-003 |
| Run an initiative | Resume a step that ended its turn | none | gap: out of scope |

## Gaps

- Resume a step that ended its turn: already built in 0000354. This step only changes the continue prompt text.
