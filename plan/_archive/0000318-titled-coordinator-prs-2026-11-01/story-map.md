---
title: "Story Map - 0000318-titled-coordinator-prs"
summary: "The backbone of activities and steps, with the requirement that covers each step."
status: "active"
version: "0.44.0"
---
# Story Map - 0000318-titled-coordinator-prs

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run an initiative | The coordinator reads that nothing commits directly on the initiative branch | US-001 | REQ-001 |
| Run an initiative | The coordinator raises a titled PR for queued work and lands it | US-002 | REQ-002 |
| Ship a step | Ship records the PR number before the squash | US-003 | REQ-003 |
| Guard the merge | `merge-guard` allows exactly what it allows today | US-004 | REQ-004 |
| Check the history | A script fails on an untitled commit | none | gap: out of scope |

## Gaps

- The history script: out of scope. Step 7 adds it.
