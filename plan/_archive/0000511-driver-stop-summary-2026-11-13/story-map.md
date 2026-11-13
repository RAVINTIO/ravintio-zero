---
title: "Story Map - 0000511-driver-stop-summary"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000511-driver-stop-summary

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| End a driver run | List the steps the run merged | US-001 | REQ-001 |
| End a driver run | List the fixes the driver made | US-001 | REQ-001 |
| End a driver run | Print the one action left | US-002 | REQ-002 |
| Read the docs | Find the summary lines in the driver comment and the standards | US-001, US-002 | REQ-003 |
| Run the driver | Write the summary to a file | none | gap: out of scope |

## Gaps

- Summary file: the scope lists a file on disk as out of scope. The block on stdout reaches the human and the watcher.
