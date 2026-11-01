---
title: "Story Map - 0000320-quiet-session-start"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000320-quiet-session-start

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Start a session | Read the load instruction once | US-001 | REQ-001 |
| Start a session | Read migration findings only while they need action | US-002 | REQ-002 |
| Keep migration state | Record finished and inapplicable migrations outside the pack | US-002 | REQ-003 |
| Keep migration state | Carry existing `_done/` records into the record | US-002 | REQ-003 |
| End a turn | Get a prefix warning only for a missing prefix | US-003 | REQ-004 |
| Start a session | See other no-action findings | none | gap: out of scope |

## Gaps

- See other no-action findings: the pack-version check is the only other one. Entry 0000272 owns it, so the step leaves it out.
