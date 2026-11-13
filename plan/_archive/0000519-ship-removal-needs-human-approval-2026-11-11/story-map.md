---
title: "Story Map - 0000519-ship-removal-needs-human-approval"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000519-ship-removal-needs-human-approval

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Archive the run | The step copies `plan/current/` to the archive and removes it with `git rm -r -q plan/current` | US-001 | REQ-001 |
| Finish P2 | The agent writes docs, then runs the full suite with no file change | US-002 | REQ-002 |

## Gaps

- None.
