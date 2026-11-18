---
title: "Story Map - 0000558-plan-only-push-short-ci"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000558-plan-only-push-short-ci

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Push to a pull request | A second push lands while a run is active | US-001 | REQ-001 |
| Push to a pull request | The closing push changes only plan files | US-002 | REQ-002 |
| Merge to main | A push to main tags a release | none | gap: out of scope |

## Gaps

- A push to main tags a release. The workflow already covers it, and REQ-001 only protects it.
