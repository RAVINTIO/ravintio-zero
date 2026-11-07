---
title: "Story Map - 0000359-safe-parallel-commits"
summary: "The backbone of activities and steps, with the requirement that covers each step."
status: "active"
version: "0.1.0"
---
# Story Map - 0000359-safe-parallel-commits

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run parallel units | The step session runs no tree-wide git command under a running subagent | US-001 | REQ-001 |
| Test a clean tree | The unit tests in a scratch clone | US-002 | REQ-001 |
| Commit a unit | The unit commits with `-- {paths}` and never amends | US-003 | REQ-002 |
| Block the commands with a hook | A hook refuses the commands | none | gap: out of scope |

## Gaps

- A blocking hook for these commands (gap: out of scope). The entries ask for rules in text.
