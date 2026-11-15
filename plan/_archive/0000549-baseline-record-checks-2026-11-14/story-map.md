---
title: "Story Map - 0000549-baseline-record-checks"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000549-baseline-record-checks

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Record the baseline | Read runner output | US-001 | REQ-001 |
| Record the baseline | Write the baseline file | US-001 | REQ-001 |
| Compare a run | Read the baseline file | US-002 | REQ-002 |
| Compare a run | Report inherited and new suites | none | gap: out of scope |

## Gaps

- Report inherited and new suites: the script already does this, and this feature leaves it unchanged.
