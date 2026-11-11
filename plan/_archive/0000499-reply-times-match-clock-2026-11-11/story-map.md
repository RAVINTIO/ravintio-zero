---
title: "Story Map - 0000499-reply-times-match-clock"
summary: "The backbone of activities and steps, with the requirement that covers each step."
status: "active"
version: "0.1.0"
---
# Story Map - 0000499-reply-times-match-clock

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Know the time | The agent gets the local time after each tool call | US-001 | REQ-001 |
| Know the rule | The agent reads that every timestamp comes from a fresh clock read | US-002 | REQ-002 |
| Review the reply | The Stop hook warns on a time over 2 minutes off or an unknown status | US-003 | REQ-003 |
| Watch the feed | The watcher stamps each activity line with its own time | US-004 | REQ-004 |

## Gaps

- None.
