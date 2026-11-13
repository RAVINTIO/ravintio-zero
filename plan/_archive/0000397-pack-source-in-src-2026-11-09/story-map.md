---
title: "Story Map - 0000397-pack-source-in-src"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000397-pack-source-in-src

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Move the source | Rename the folder with `git mv` and no edit | US-001 | REQ-001 |
| Install the copy | Copy the source back to `ravintio-zero/` | US-002 | REQ-002 |
| Check parity | Compare the two folders byte for byte | US-002 | REQ-002 |
| Retarget tooling | Run tests against the source | US-003 | REQ-003 |
| Retarget tooling | Run CI checks against the source | US-003 | REQ-003 |
| Refresh | Follow a written route to refresh the copy | US-004 | REQ-004 |
| Guard | Cover `src/ravintio-zero/` in each guard | US-005 | REQ-005 |
| Document | Record the layout in component docs | US-004 | REQ-004 |
| Consumer install | Keep the consumer path | none | gap: out of scope |

## Gaps

- Consumer install keeps `ravintio-zero/`. The design lists it as a constraint, so it adds no story.
