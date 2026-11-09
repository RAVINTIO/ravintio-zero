---
title: "Story Map - 0000391-standards-archetypes"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000391-standards-archetypes

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Override a file | Put a standard or template in `ravintio-overrides/` | US-001 | REQ-001 |
| Override a file | Keep hook-enforced rules in force | US-002 | REQ-002 |
| Pick an archetype | Browse the catalogue with `archetype list` | US-003 | REQ-003 |
| Pick an archetype | Run `archetype use {kind}/{name}` | US-003 | REQ-003 |
| Pick an archetype | Read the clash and threshold report | US-004 | REQ-004 |
| Pick an archetype | Choose one of the four starter archetypes | US-005 | REQ-005 |
| Enforce a constraint | Fail P3 when a gate breaks | US-006 | REQ-006 |
| Follow a writing pick | Print the output style and `AGENTS.md` section | US-007 | REQ-007 |

## Gaps

- Uninstall an archetype: gap: out of scope. The scope file defers it, and a developer deletes the copied files by hand.
