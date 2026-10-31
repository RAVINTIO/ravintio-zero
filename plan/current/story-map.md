---
title: "Story Map - 0000317-block-forced-adds"
summary: "The backbone of activities and steps, with the requirement that covers each step."
status: "active"
version: "0.43.0"
---
# Story Map - 0000317-block-forced-adds

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Stage files | A step reads the rule against forced adds | US-001 | REQ-001 |
| Stage files | The hook blocks a forced add | US-002 | REQ-002 |
| Clone the repo | The tracked `.gitignore` lists the driver paths | US-003 | REQ-003 |
| Ship a change | Ship and CI fail on a committed ignored file | US-004 | REQ-004 |
| Stage files | Block `git update-index --add` and other routes | none | gap: out of scope |

## Gaps

- Other staging routes: out of scope. The CI check from REQ-004 catches any ignored file that reaches a commit.
