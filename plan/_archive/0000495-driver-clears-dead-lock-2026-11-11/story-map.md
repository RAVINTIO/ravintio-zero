---
title: "Story Map - 0000495-driver-clears-dead-lock"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000495-driver-clears-dead-lock

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Start the driver | Read the lock when the write fails | US-001 | REQ-001 |
| Start the driver | Take a lock whose process is gone | US-001 | REQ-001 |
| Start the driver | Refuse a lock whose process runs | US-002 | REQ-002 |
| Start the driver | Refuse a lock that holds no pid or is a symlink | US-002 | REQ-002 |
| Read the rule | Find the rule in the driver and the standards | US-001 | REQ-003 |
| Start the driver | Start the driver with the old rule | none | gap: out of scope |

## Gaps

- Start the driver with the old rule: no story needs it. The old refusal stays for every lock that is not provably dead.
