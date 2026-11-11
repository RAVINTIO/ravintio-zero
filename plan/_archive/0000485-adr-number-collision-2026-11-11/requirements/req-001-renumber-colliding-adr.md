---
title: "Requirement: REQ-001 - Renumber a colliding ADR"
summary: "The module renumbers a PR ADR whose number a base ADR also holds."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Renumber a colliding ADR

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000485-adr-number-collision
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I merge parallel steps that reserved one ADR number, so that each ADR keeps a unique number.

## Functional Requirements
- `renumberCollisions({ root, ours, theirs })` in `id-collisions.mjs` runs on a repo whose HEAD is the base merge. `ours` is the PR head before the merge and `theirs` is the base head.
- An ADR collides when the PR added `docs/adr/{NNNN}-{slug}.md` since the merge base, and the merged tree holds another file with the same `NNNN`.
- Each colliding ADR gets the next number above the highest `docs/adr/` number and the counter. The module renames the file with `git mv`.
- The module rewrites the title number, the heading, and the `File` line in the renamed file. It rewrites the matching row and link in `docs/decisions-index.md`.
- The module rewrites `ADR-{old}` and `{old}-{slug}` in files that the PR added or changed since the merge base.
- The module raises `docs/adr/.next-id` to one above the highest number, with the same width.
- The module returns one entry per change, `{ kind: "adr", from, to }`.

## Acceptance Criteria
- [ ] AC-1: the module renumbers a colliding ADR
  - Given the PR added `0301-a.md` and the base added `0301-b.md`
  - When the module runs on the merged tree
  - Then `0301-b.md` stays, the PR file becomes `0302-a.md`, and its heading, title, and index row hold 0302
- [ ] AC-2: references and the counter follow
  - Given a file the PR changed cites `ADR-0301`
  - When the module renumbers the PR's ADR
  - Then that file cites `ADR-0302` and `docs/adr/.next-id` holds `0303`
- [ ] AC-3: no collision leaves the tree as it was
  - Given the PR and the base added ADRs with different numbers
  - When the module runs
  - Then it returns an empty list and the tree stays as it was

## Dependencies
- 0000456 `shared-files.mjs` keeps both index rows during the conflict resolution.
