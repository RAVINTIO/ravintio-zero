---
title: "Backlog Entry: 0000263 - write component paths at design time"
summary: "The design template has no Component Paths section, so gate-write blocks a subagent that writes a planned path."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000263 - write component paths at design time

**Source feature:** 0000245-boot-rules-into-skills
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-28

---

## Problem

At P2, `gate-write` blocked a subagent's first write to `ravintio-zero/tests/`, because `design.md` had no `## Component Paths` section. The design template does not ask for one. The run lost one round trip while the orchestrator added the section.

## Suggested Action

Add a `## Component Paths` section to `ravintio-zero/templates/design.template.md`. Tell P0 to list every folder the plan will write.

## Wanted outcome

- The design template holds a `## Component Paths` section above `## Scope`.
- A test checks that a design written from the template lets `gate-write` pass a path under a listed folder.

## Why Deferred

Found while shipping 0000245. The fix is outside that feature. Source retrospective: `plan/retrospectives/0000245-boot-rules-into-skills-2026-10-28.md`.
