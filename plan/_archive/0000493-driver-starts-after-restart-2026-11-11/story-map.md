---
title: "Story Map - 0000493-driver-starts-after-restart"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000493-driver-starts-after-restart

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Hand over | A merge changes the driver or the watcher | US-001 | REQ-001 |
| Hand over | The old driver starts a successor and gives it the lock | US-001 | REQ-001 |
| Hand over | The old driver stays out of new starts and the queue | US-001 | REQ-001 |
| Adopt | The successor reads the control folders | US-002 | REQ-002 |
| Adopt | The successor skips a step that a live driver runs | US-002 | REQ-002 |
| Adopt | The successor queues a step that wrote ready | US-002 | REQ-002 |
| Stop | A handed-over step blocks | US-003 | REQ-003 |
| Stop | The successor stops new starts | US-003 | REQ-003 |
| Describe | The standards and the driver header state the handoff | US-004 | REQ-004 |
| Describe | The initiative skill tells the coordinator what to start | US-004 | REQ-004 |
| Recover | The old driver dies with sessions running | none | gap: added as US-002 |
| Run alone | The chart has no concurrency field | none | gap: out of scope |

## Gaps

- The old driver dies with sessions running. The successor restarts them from the dead pid. REQ-002 AC-3 covers it.
- The chart has no concurrency field. The serial path holds no running steps, so it needs no handoff.
