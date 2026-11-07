---
title: "Story Map - 0000355-codeql-and-branch-cleanup"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000355-codeql-and-branch-cleanup

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Scan a PR | CodeQL runs on a PR into `main` or `initiative/**` | US-001 | REQ-001 |
| Review a PR | The P3 checklist names incomplete escaping | US-002 | REQ-002 |
| Add a CI job | A marked job needs no edit to the shape test | US-003 | REQ-003 |
| Merge a PR | CI deletes the merged head branch | US-004 | REQ-004 |
| Keep records true | Entry 0000323 matches the repo | US-005 | REQ-005 |
| Turn off default setup | A human switches off CodeQL default setup in repo settings | none | gap: out of scope |

## Gaps

- Turning off default setup needs repo admin rights. The step stops for the human before it merges if default setup is still on (gap: out of scope).
