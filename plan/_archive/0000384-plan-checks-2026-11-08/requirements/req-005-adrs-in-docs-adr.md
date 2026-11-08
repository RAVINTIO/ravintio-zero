---
title: "Requirement: REQ-005 - ADRs in docs/adr"
summary: "Every ADR lives in docs/adr under a repo-wide four-digit number, with a counter, a migration, and a complete index."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - ADRs in docs/adr

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000384-plan-checks
**Source:** US-005
**Priority:** must-have

## User Story

As a maintainer, I want every ADR in `docs/adr/` under a repo-wide number, so that no archive pass loses a decision and no number repeats.

## Functional Requirements
- ADR files are named `{NNNN}-{slug}.md` in `docs/adr/`. The counter is `docs/adr/.next-id`, reserved with `node ravintio-zero/scripts/reserve-id.mjs --file docs/adr/.next-id`.
- The plan skill reserves a number for each new ADR, commits the counter on its own, and writes the ADR to `docs/adr/` with status `proposed`. Ship sets it to `accepted`.
- The ADR template gains a `Component` front matter field. A superseding ADR names the one it replaces, and the old ADR gains `Superseded by {number}`. Nobody deletes an ADR.
- Ship adds one row per new ADR to `docs/decisions-index.md`. The archive links to `docs/adr/` and holds no copy.
- Migration 0009 (`ravintio-zero/migrations/`) moves archived ADRs in feature order, then ADR order. It restores the ADRs of features 0000001 to 0000029 from git history, rewrites `Supersedes` references, replaces archived copies with links, rebuilds the index, and sets `.next-id` to one past the highest number. Its `Applies when:` condition covers the pack source.
- `consistency-check.mjs` resolves ADR references against `docs/adr/` as well as `plan/current/adr/`.

## Acceptance Criteria
- [ ] AC-1: Unique numbers
  - Given the migrated repo
  - When a test lists `docs/adr/`
  - Then every file name starts with a unique four-digit number and no `plan/_archive/*/adr/` file remains
- [ ] AC-2: Index complete
  - Given `docs/adr/` and `docs/decisions-index.md`
  - When a test compares them
  - Then every ADR file has one index row and every row points at an existing file
- [ ] AC-3: Migration is idempotent
  - Given a repo the migration already ran on
  - When it runs again
  - Then it changes no file

## Dependencies
- `reserve-id.mjs` (existing, accepts `--file`)
