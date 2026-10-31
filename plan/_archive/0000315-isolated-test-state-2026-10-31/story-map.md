---
title: "Story Map - 0000315-isolated-test-state"
summary: "The backbone of activities and steps, with the requirement that covers each step."
status: "active"
version: "0.41.2"
---
# Story Map - 0000315-isolated-test-state

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run the suite | The runner starts each suite with a clean environment | US-001 | REQ-001 |
| Run the suite | No suite writes the real repo state | US-002 | REQ-002 |
| Run the suite | The runner compares the tree before and after | US-002 | REQ-003 |
| Run the suite | `test-0000164-req-007` reads the file that holds the rules | US-003 | REQ-004 |
| Run the suite | Compare ignored files | none | gap: out of scope |

## Gaps

- Compare ignored files: out of scope. Driver logs change during a step, so the check reads tracked and untracked files only.
