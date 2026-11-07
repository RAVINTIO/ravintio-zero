---
title: "Requirement: REQ-005 - Driver and watcher time"
summary: "Driver and watcher lines start with hh:mm, and the Reply Conventions docs name the time."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-005 - Driver and watcher time

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000388-replies-and-questions
**Source:** US-001
**Priority:** must-have

## User Story

> One requirement doc = one user story.

As a human on the loop, I see `hh:mm` before every reply and driver line, so that I know when each happened.

Backlog entry: 0000257. This requirement covers the driver, the watcher, and the docs. REQ-001 covers the hooks.

## Functional Requirements
- The `out` function in `initiative-run.mjs` starts every printed line with the local `hh:mm` and a space.
- The `out` function in `initiative-watch.mjs` does the same.
- `standard-boot.md`, `codex-boot.md`, the orchestrator skill, the initiative skill, and `roadmap-standards.md` name the time in Reply Conventions.
- `hook-enforcement.md` describes the time if it describes the hook.
- New orchestrator `SKILL.md` text stays within the 9000 byte cap, with rule text in `references/`.

## Acceptance Criteria
- [ ] AC-1: Driver and watcher lines
  - Given a driver run and a watcher run in a fixture workspace
  - When each prints a line
  - Then the line matches `^[0-2][0-9]:[0-5][0-9] ` followed by a known prefix
- [ ] AC-2: Docs name the time
  - Given the Reply Conventions text in the boot templates, orchestrator skill, initiative skill, and `roadmap-standards.md`
  - When a test reads it
  - Then each names the `hh:mm` time before the prefix
  - And the size caps for the boot template and orchestrator skill still hold

## Dependencies
- REQ-001, for the accepted form of the prefix.
