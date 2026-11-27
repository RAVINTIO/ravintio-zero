---
title: "Story Map - 0000580-log-non-tdd-units"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000580-log-non-tdd-units

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Define the unit | Name class `docs` and its tier row in the standards | US-001 | REQ-001 |
| Log the unit | Append `RED:` and `GREEN:` lines with the class | US-002 | REQ-002 |
| Check the log | Pass a `docs` unit with both markers, fail it without them | US-003 | REQ-003 |
| Report the log | Count `docs` units in their own row | US-004 | REQ-004 |
| Rewrite an archived log | Convert the old `U-004` line | none | gap: out of scope |

## Gaps

- Rewrite an archived log: the brief rules out a rewrite of archived logs, so the step is out of scope.
