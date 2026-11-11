---
title: "Story Map - 0000489-question-only-for-questions"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000489-question-only-for-questions

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Wait for work | The step keeps working while its suites run and ends only at a valid stop | US-001 | REQ-001 |
| Ask the human | The step uses `Question:` only for a real question and ends the line with a question mark | US-001 | REQ-001 |
| Review the reply | The Stop hook warns on a `Question:` line with no question mark | US-002 | REQ-002 |

## Gaps

- None.
