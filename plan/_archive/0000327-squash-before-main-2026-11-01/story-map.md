---
title: "Story Map - 0000327-squash-before-main"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000327-squash-before-main

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Start a run outside an initiative | Cut a `hotfix/` branch | US-004 | REQ-005 |
| Ship a chore or hotfix | Squash to one commit, then wait for CI | US-001 | REQ-003 |
| Raise a PR into main | Use an allowed branch prefix | US-002 | REQ-004 |
| Raise a PR into main | Fail CI on a PR that breaks the rule | US-003 | REQ-001, REQ-002 |
| Raise a PR into main | Block a force-push at the hook | none | gap: out of scope |

## Gaps

- Block a force-push at the hook: no hook blocks a force-push today. The entry limits the permission in skill text and checks the result in CI.
