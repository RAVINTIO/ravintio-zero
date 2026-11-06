---
title: "Story Map - 0000357-guard-gaps-closed"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000357-guard-gaps-closed

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run a guarded call | The guard blocks when the launcher is missing | US-001 | REQ-001 |
| Add a file to git | The guard blocks `git stage -f`, a subshell, and a variable flag | US-002 | REQ-002 |
| Use Codex | Codex blocks the same forced-add forms | US-003 | REQ-003 |
| Clone the repo | A fresh clone ignores the prefix-misses log | US-004 | REQ-004 |
| Edit the hook files by hand | A hand edit that breaks a hook command | none | gap: out of scope |

## Gaps

- A hand edit of a hook command in `settings.json` can drop the suffix. Setup restores it on the next run (gap: out of scope).
