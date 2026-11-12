---
title: "Story Map - 0000507-hook-check-after-setup"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000507-hook-check-after-setup

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Check hooks | Read the hook commands from `.claude/settings.json` | US-001 | REQ-001 |
| Check hooks | Run each hook with `CLAUDE_PROJECT_DIR` and a fixed sample input | US-001 | REQ-001 |
| Check hooks | Judge each result and report a hook that fails | US-001 | REQ-002 |
| Run after setup | Run the check after the driver runs setup | US-002 | REQ-003 |
| Run after setup | Stop the driver on a failure | US-002 | REQ-003 |
| Fix a failing hook | Edit the hook or rerun setup | none | gap: out of scope |

## Gaps

- Fix a failing hook: the check reports the failure. A person or agent repairs the hook, so the step is out of scope.
