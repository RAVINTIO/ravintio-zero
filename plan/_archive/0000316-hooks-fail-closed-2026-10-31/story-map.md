---
title: "Story Map - 0000316-hooks-fail-closed"
summary: "The backbone of activities and steps, with the requirement that covers each step."
status: "active"
version: "0.42.0"
---
# Story Map - 0000316-hooks-fail-closed

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run setup | Setup writes the Bash working-directory setting | US-001 | REQ-001 |
| Run a session | A hook command resolves from the project root | US-002 | REQ-002 |
| Run a session | A guard that cannot run blocks and names its script | US-003 | REQ-003 |
| Run a session | An advisory hook reports a missing script once | US-003 | REQ-004 |
| Run a session | Detect a hook that Claude Code never started | none | gap: out of scope |

## Gaps

- Detect a hook that Claude Code never started: out of scope. A missing launcher still exits 1, and the setup rerun check runs every hook.
