---
title: "Story Map - 0000503-planned-restart-exit-code"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000503-planned-restart-exit-code

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Stop for a restart | Build the `Restart:` line after a merge | US-001 | REQ-001 |
| Stop for a restart | Exit 75 in the serial path | US-001 | REQ-001 |
| Stop for a restart | Exit 75 in the concurrent path | US-001 | REQ-001 |
| Stop for a failure | Keep exit 1 for `Blocked:` and bare `Setup:` | US-002 | REQ-002 |
| Stop for a failure | Keep exit 1 when a failure follows a restart hit | US-002 | REQ-002 |
| Read the docs | Find the code in the driver comment, the standards, and the skill | US-003 | REQ-003 |
| Watch the driver | Show the exit code in the watcher | none | gap: out of scope |

## Gaps

- Watcher: it reads the lock and never sees the exit code. The scope lists it as out of scope.
