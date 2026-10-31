---
title: "Story Map - 0000313-driver-setup-stop"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000313-driver-setup-stop

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run a step | A merged step changes an installed pack file | US-001 | REQ-001 |
| Run a step | A step changes only tests | US-001 | REQ-001 |
| Run a step | A step triggers both stops | US-001 | REQ-001 |
| Handle the stop | The initiative skill reads the command source and runs it | US-002 | REQ-002 |
| Handle the stop | The initiative skill checks the hooks and starts a new driver | US-002 | REQ-002 |
| Document the stop | The standards name the stop | US-003 | REQ-003 |
| Handle the stop | Setup runs from the driver | none | gap: out of scope |

## Gaps

- Setup runs from the driver: out of scope. The driver never edits the working tree, and the skill owns the rerun.
