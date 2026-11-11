---
title: "Feature Brief - Parallel steps reserve distinct ids"
summary: "The merge queue renumbers an ADR or a backlog entry whose id another merged step already uses."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Parallel steps reserve distinct ids

**Feature ID:** 0000485-adr-number-collision

Source: backlog entry 0000479-adr-number-collision, from the 0000462 retrospective.

## Business Goal

Steps that run at once each reserve ADR numbers from the counter on their own branch. Steps 32, 33, and 35 all reserved ADR 0301, and step 35 renumbered its ADR by hand during the base merge. Backlog ids collide the same way: two entries took 0000479. The merge queue resolves the counter and the index rows but never sees two ADR files with one number. The queue now renumbers the colliding file, so a merge needs no hand edit.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| ADR renumber | As a maintainer, I merge parallel steps that reserved one ADR number, so that each ADR keeps a unique number with no hand edit. | must-have | 1 |
| Backlog id renumber | As a maintainer, I merge parallel steps that filed entries under one id, so that each entry keeps a unique id. | must-have | 1 |

## Wanted outcome

- After the base merge, the queue finds each ADR file that the PR added under a number that a base ADR file also holds.
- The queue gives the PR's ADR the next free number. It updates the file, the index row, the counter, and the references in files the PR changed.
- The queue does the same for a backlog entry folder, and rebuilds `plan/backlog/index.md`.
- The queue commits the renumber as its own commit before the CI wait, and prints one `renumbered:` line for each change.
- The queue changes nothing when no id collides.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the queue, the new module, the standards, and the tests |

### Data Ownership

No data store.

### Integration Points

`merge-queue.mjs` calls the new module after the base merge, in both the clean path and the shared-file conflict path.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js script, Markdown standards, Bash suites already in the pack |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- A module `id-collisions.mjs` that renumbers a colliding ADR and a colliding backlog entry.
- The call in `merge-queue.mjs` and the `renumbered:` output line.
- The `## Merge queue` section of `roadmap-standards.md`.
- Tests, an ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.
- The renumber of the second 0000479 entry to 0000513, done at P0.

### Out of Scope
- Collisions between ids that no merged step shares, such as two branches that have not merged.
- Renumbering feature ids or initiative ids.
- A change to `reserve-id.mjs`.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| No-collision runs | The module changes no file and adds no commit | the module test |
| Safety | The module never rewrites pushed history and never force-pushes | the queue test |

## Constraints and Assumptions

### Constraints
- No new library or service.
- The change widens no guard.
- Node.js built-ins only. Every git call takes an argument array.

### Assumptions
- A PR's references to its own colliding number sit in files the PR changed. Impact if wrong: a stale reference stays, and a later review finds it.
- A PR cannot cite the base's new ADR, because the base added it after the PR branched. Impact if wrong: the module renumbers a reference it should keep.

## Scenario Paths

**Happy path:** the PR holds `0301-a.md`, the base holds `0301-b.md`. The base merge is clean. The module renames the PR's file to `0302-a.md`, fixes its heading and its index row, raises the counter to 0303, and commits.

**Alternative path:** no id collides. The queue prints nothing and adds no commit.

**Error / sad path:** a git failure or an unreadable file stops the queue with a message. A rerun starts from the same tree.

**Cross-session continuity:** a rerun after a stop finds the same collision, or finds none if the renumber commit exists. The module is idempotent.

## Acceptance Criteria

- [ ] Two ADRs with one number merge, and the PR's ADR gets a free number with its file, heading, index row, references, and counter updated.
- [ ] Two backlog entries with one id merge, and the PR's entry gets a free id with the index rebuilt.
- [ ] A merge with no collision adds no commit and prints no `renumbered:` line.
- [ ] The queue runs the module after a clean base merge and after a shared-file conflict resolution.
- [ ] `roadmap-standards.md` describes the renumber.
