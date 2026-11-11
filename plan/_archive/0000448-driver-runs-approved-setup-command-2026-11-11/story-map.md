---
title: "Story Map - 0000448-driver-runs-approved-setup-command"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000448-driver-runs-approved-setup-command

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Find the approved command | The helper reads the `Confirmation:` row for setup | US-001 | REQ-001 |
| Find the approved command | The helper accepts only the pack `setup.sh` with flag words | US-001 | REQ-001 |
| Run the command | The driver runs it at a `Setup:` stop and continues | US-001 | REQ-002 |
| Run the command | The driver stops when the row is missing, the form differs, or the command fails | US-001 | REQ-002 |
| Run the command | The driver still stops at a `Restart:` hit | US-001 | REQ-002 |
| Describe the behaviour | The standards and the initiative skill state the rule | US-001 | REQ-003 |

## Gaps

None.
