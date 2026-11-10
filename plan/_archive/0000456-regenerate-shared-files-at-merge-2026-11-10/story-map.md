---
title: "Story Map - 0000456-regenerate-shared-files-at-merge"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000456-regenerate-shared-files-at-merge

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Merge a step PR | Merge the base into the PR branch | US-001 | REQ-001 |
| Merge a step PR | Resolve counter and index conflicts | US-001 | REQ-001 |
| Merge a step PR | Stop on any other conflict | US-001 | REQ-001 |
| Land coordinator work | Compare changed files with open step PRs | US-002 | REQ-002 |
| Land coordinator work | Name each overlapping PR and file | US-002 | REQ-002 |

## Gaps

- Generate the prose of `architecture-overview.md`: gap: out of scope. The brief excludes it.
