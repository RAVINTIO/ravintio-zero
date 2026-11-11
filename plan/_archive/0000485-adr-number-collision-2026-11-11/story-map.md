---
title: "Story Map - 0000485-adr-number-collision"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000485-adr-number-collision

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Merge a step PR | The queue merges the base into the PR branch | none | gap: out of scope, the queue already does this |
| Keep ADR numbers unique | The queue finds a PR ADR whose number a base ADR holds | US-001 | REQ-001 |
| Keep ADR numbers unique | The queue renames the file and fixes the heading, index row, references, and counter | US-001 | REQ-001 |
| Keep backlog ids unique | The queue finds a PR entry whose id a base entry holds | US-002 | REQ-002 |
| Keep backlog ids unique | The queue renames the folder, fixes the entry, and rebuilds the index | US-002 | REQ-002 |
| Merge a step PR | The queue runs the renumber after a clean merge and after a shared-file resolution | US-001, US-002 | REQ-002 |

## Gaps

- The base merge step already exists, so it needs no new requirement.
