---
title: "Story Map - 0000446-drain-ready-prs-after-a-stop"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000446-drain-ready-prs-after-a-stop

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Merge ready PRs | Queue one ready PR | none | existing behaviour |
| Merge ready PRs | Keep queueing after a failure | US-001 | REQ-001 |
| Merge ready PRs | Report each failure | US-001 | REQ-001 |
| Read the rules | Find the drain rule | US-002 | REQ-002 |
| Recover | Queue a failed step again after a restart | none | gap: out of scope |

## Gaps

- Queue a failed step again after a restart: the driver already queues each `ready` step on restart. No change needed.
