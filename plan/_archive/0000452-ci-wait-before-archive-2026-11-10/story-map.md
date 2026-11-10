---
title: "Story Map - 0000452-ci-wait-before-archive"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000452-ci-wait-before-archive

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Ship an initiative step | Raise the PR and wait for CI | US-001 | REQ-001 |
| Ship an initiative step | Fix a failing check while the run is open | US-001 | REQ-001 |
| Ship an initiative step | Archive the run as the last push | US-001 | REQ-001 |
| Hand off to the merge queue | Check that every check passed on the head | US-002 | REQ-002 |
| Hand off to the merge queue | Write ready | US-002 | REQ-002 |

## Gaps

- None. The brief's stories cover every step.
