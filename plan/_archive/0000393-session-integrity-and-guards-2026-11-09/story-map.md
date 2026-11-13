---
title: "Story Map - 0000393-session-integrity-and-guards"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000393-session-integrity-and-guards

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Guard writes | Block a shell write to a gated path | US-001 | REQ-001 |
| Guard git | Block a forced add by option value or brace | US-002 | REQ-002 |
| Detect updates | Compare the pack with its own record | US-003 | REQ-003 |
| File backlog | Check an entry's wording at filing | US-004 | REQ-004 |

## Gaps

- Shell writes by `cp`, `mv`, `dd`, or a script: gap: out of scope. The entry names redirects, `tee`, and `sed -i`.
