---
title: "Story Map - 0000536-pending-migrations-reach-the-human-early"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000536-pending-migrations-reach-the-human-early

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Chart | List each pending migration | US-001 | REQ-001 |
| Chart | Record the human's answer as a `Migration:` row | US-001 | REQ-001 |
| Run a step | Run a migration that has a row | US-002 | REQ-002 |
| Run a step | Log a migration that has no row and carry on | US-002 | REQ-002 |
| Report | Raise each logged migration to the human | US-003 | REQ-003 |
| Report | Chart a migration answer after the run starts | none | gap: out of scope |

## Gaps

- Chart a migration answer after the run starts: out of scope. The coordinator raises the line, and a later chart or coordinator PR holds the answer.
