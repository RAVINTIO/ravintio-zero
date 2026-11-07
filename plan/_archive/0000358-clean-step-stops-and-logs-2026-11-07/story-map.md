---
title: "Story Map - 0000358-clean-step-stops-and-logs"
summary: "The backbone of activities and steps, with the requirement that covers each step."
status: "active"
version: "0.1.0"
---
# Story Map - 0000358-clean-step-stops-and-logs

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Ask a routine question | The reply carries `Question:` and not `Blocked:` | US-001 | REQ-001 |
| Log a phase | Every logged time comes from the clock and the check fails a future time | US-002 | REQ-002 |
| Close a phase | The check fails a closed block with no `Complete:` or `Skipped:` line | US-003 | REQ-003 |
| Run the tests | The runner names each failed suite | US-004 | REQ-004 |
| Edit the resume detection counts | Count `Question:` lines | none | gap: out of scope |

## Gaps

- Resume detection and governance counts keep reading `Blocked:` unchanged (gap: out of scope).
