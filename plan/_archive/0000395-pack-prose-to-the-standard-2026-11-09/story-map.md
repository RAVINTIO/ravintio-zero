---
title: "Story Map - 0000395-pack-prose-to-the-standard"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000395-pack-prose-to-the-standard

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Fix breaches | Rewrite the prose of each file in scope | US-001 | REQ-001 |
| Fix breaches | Keep meaning, anchors, and parsed headings | US-001 | REQ-001 |
| Hold the line | Lower the baseline with each batch | US-002 | REQ-002 |
| Hold the line | Update tests that pin rewritten wording | US-002 | REQ-002 |
| Hold the line | Leave plan history records as they are | none | gap: out of scope |

## Gaps

- Plan history records under `plan/changelog/`, `plan/retrospectives/`, `plan/postmortems/`, and `plan/backlog/` keep their baseline. They are historical records, and the backlog entry names skills, standards, templates, and `docs/`.
