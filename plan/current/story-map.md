---
title: "Story Map - 0000321-backlog-triage"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000321-backlog-triage

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| File an entry | Set a priority and a theme | US-001 | REQ-001 |
| Read the backlog | Read the generated index | US-002 | REQ-002 |
| Merge a change | Fail CI on a stale index | US-002 | REQ-003 |
| Start P0 | Review stale entries, then pick up in index order | US-003 | REQ-004 |
| Review the backlog | List entries older than the review age | US-004 | REQ-004 |
| Adopt the feature | Give existing entries a default priority and theme | US-005 | REQ-005 |
| Review the backlog | Close an entry that a later change made obsolete | none | gap: out of scope |

## Gaps

- Close an entry that a later change made obsolete: the review asks the question, and the human decides. The script closes nothing.
