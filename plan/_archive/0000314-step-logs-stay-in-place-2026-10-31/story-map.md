---
title: "Story Map - 0000314-step-logs-stay-in-place"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000314-step-logs-stay-in-place

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run the suite in a step | The phase guard reads a populated step log | US-001 | REQ-001 |
| Run the suite in a step | A stale cite in a tracked skill still fails | US-001 | REQ-001 |
| Run a step | The step leaves driver files where they are | US-002 | REQ-002 |
| Run the suite in a step | A full run leaves every step log in place | US-002 | REQ-003 |
| Run the suite in a step | Scan tracked files only | none | gap: out of scope |

## Gaps

- Scan tracked files only: out of scope. The chart rejected it, because it hides new untracked skill files.
