---
title: "Requirement: REQ-002 - index generator and check"
summary: "A script writes plan/backlog/index.md and checks that it is current."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - index generator and check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000321-backlog-triage
**Source:** US-002
**Priority:** must-have

## User Story

As a developer, I read `plan/backlog/index.md`, so that I see every open entry with its priority and theme at a glance.

## Functional Requirements
- `ravintio-zero/scripts/backlog-index.mjs` reads the frontmatter and `**Date filed:**` line of each `plan/backlog/{id}-{slug}/entry.md`. It reads no other body text.
- With no flag it writes `plan/backlog/index.md`. The index groups entries by theme (alphabetical, `unsorted` last) and orders each group by priority (`high`, `medium`, `low`), then id. Each row holds id, title, priority, status, and date filed.
- `--check` writes nothing. It exits 1 when the committed index differs from a fresh run.
- An entry with unreadable frontmatter or an unknown priority is malformed. The script lists it on stderr, exits 1, and writes no index.
- The output is deterministic. The script prints no entry body text and treats entry text as data.
- `--root dir` sets the repository folder.

## Acceptance Criteria
- [ ] AC-1: index lists every open entry
  - Given entries with different priorities and themes
  - When the script runs
  - Then the index lists each open entry with its priority and theme, grouped by theme and ordered by priority
- [ ] AC-2: check fails on a stale index
  - Given a committed index that differs from a fresh run
  - When the script runs with `--check`
  - Then it exits 1 and writes nothing
  - And it exits 0 when the index matches
- [ ] AC-3: malformed entry stops the run
  - Given an entry with an unknown priority
  - When the script runs
  - Then it exits 1, names the entry, and writes no index

## Dependencies
none
