---
title: "Story Map - 0000390-prose-checks"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000390-prose-checks

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Check prose | Find breaches in a Markdown file | US-001 | REQ-001 |
| Check prose | Find breaches in a commit message | US-001 | REQ-001 |
| Keep the count falling | Record old breaches per file | US-002 | REQ-002 |
| Keep the count falling | Fail a raised count | US-002 | REQ-002 |
| Stop breaches at commit time | Block in `commit-msg` and pre-commit | US-003 | REQ-003 |
| Stop breaches at commit time | Block in CI | US-003 | REQ-003 |
| Review docs before ship | Run the P3 edit pass | US-004 | REQ-004 |
| See reply drift | Report a long sentence or blocklist word | US-005 | REQ-005 |
| See reply drift | Register the hook in both setup scripts | US-005 | REQ-005 |
| Fix old breaches | Rewrite existing pack prose | none | gap: out of scope |

## Gaps

- Rewrite existing pack prose: out of scope. Step 19 owns it.
