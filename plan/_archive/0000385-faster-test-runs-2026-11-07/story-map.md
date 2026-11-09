---
title: "Story Map - 0000385-faster-test-runs"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000385-faster-test-runs

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Build a unit | Run the tests the unit affects | US-001 | REQ-001 |
| Finish P2 | Run the full suite once | US-001 | REQ-001 |
| Start a run | Record base-commit failures | US-002 | REQ-002 |
| Validate a run | Stop only on new failures | US-002 | REQ-002 |
| Validate a run | Run the suite in a clean clone | US-003 | REQ-003 |
| Map changed files to tests in other stacks | Pick tests by tool | none | gap: out of scope |

## Gaps

- Automatic changed-file to test mapping for other stacks is out of scope.
