---
title: "Story Map - 0000450-coordinator-status-view"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000450-coordinator-status-view

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Check the run | The coordinator runs the status script | US-001 | REQ-001 |
| Check the run | The script lists merged, ready, and running steps | US-001 | REQ-001 |
| Check the run | The script lists live stops and drops cleared ones | US-001 | REQ-001 |
| Watch the run | The watcher prints a ready event | US-002 | REQ-002 |
| Watch the run | The watcher prints a driver exit event | US-002 | REQ-002 |
| Watch the run | The watcher shows a merged step as merged | US-003 | REQ-002 |
| Watch the run | The driver prints the queue failure at once | US-002 | REQ-003 |
| Report the run | The coordinator lists decisions apart from routine fixes | US-004 | REQ-004 |

## Gaps

- None.
