---
title: "Requirement: REQ-004 - Refresh route and docs"
summary: "Write down the layout and how the installed copy refreshes."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Refresh route and docs

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000397-pack-source-in-src
**Source:** US-004
**Priority:** must-have

## User Story

As a maintainer, I follow a written refresh route, so that the copies diverge only on purpose.

## Functional Requirements
- `sync-installed.mjs` copies the source to the installed folder and `--check` compares them.
- Docs describe the two folders, the route, and the reason no symlink exists.
- `component.yml` and `docs/` follow the `src/` rules.

## Acceptance Criteria
- [ ] AC-1: Route documented
  - Given `src/ravintio-zero/docs/`
  - When you read the layout page
  - Then it names the source, the installed copy, and the refresh command
- [ ] AC-2: Refresh works
  - Given a changed source file
  - When you run `node src/ravintio-zero/scripts/sync-installed.mjs`
  - Then the installed copy matches the source

## Dependencies
- REQ-002.
