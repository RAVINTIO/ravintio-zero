---
title: "Story Map - 0000534-step-sessions-receive-clock"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000534-step-sessions-receive-clock

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run a step | Start the step session with hook events on | US-001 | REQ-001 |
| Read a step log | Find the hook output in the log | US-001 | REQ-001 |
| Check a step log | Fail when the log shows no clock | US-002 | REQ-002 |
| Read the docs | Find the flag, the check, and the proof | US-001, US-002 | REQ-003 |
| Run a step | Set the time zone of the step session | none | gap: out of scope |

## Gaps

- Time zone: the scope lists a time zone setting as out of scope. The check shows whether the clock arrived, and the ADR records the zone finding.
