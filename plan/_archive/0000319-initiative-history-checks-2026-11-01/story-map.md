---
title: "Story Map - 0000319-initiative-history-checks"
summary: "The backbone of activities and steps."
status: "active"
version: "0.45.0"
---
# Story Map - 0000319-initiative-history-checks

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Check the history | A script fails on an untitled first-parent commit | US-001 | REQ-001 |
| Check the history | CI runs the script on a PR into `main` and on pushes to `initiative/**` | US-002, US-004 | REQ-002 |
| Deliver an initiative | I-E Delivery runs the script and titles the PR | US-003 | REQ-003 |
| Guard main | CI flags a one-parent commit from an initiative PR | US-005 | REQ-004 |
| Guard main | The setup docs name the ruleset | US-005 | REQ-005 |
| Report CI on the branch | The driver reports a failed run | none | gap: out of scope |

## Gaps

- Driver reporting of CI state: out of scope. Recorded as deferred.
