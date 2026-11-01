---
title: "Backlog Entry: 0000280 - keep ADRs in docs/adr with repo-wide numbers"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000280 - keep ADRs in docs/adr with repo-wide numbers

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Each feature writes its ADRs to `plan/current/adr/`, and ship moves them to `plan/_archive/{feature}/adr/`. The archive is the only home of an ADR's text, and that causes three problems:

- **ADRs get lost.** Feature 0000030 emptied `plan/_archive/` and removed every ADR from features 0000001 to 0000029. `docs/decisions-index.md` says they now exist only in git history.
- **Numbers repeat.** Each feature numbers from ADR-001, so a decision is known only as "0000034 ADR-001". Supersession chains across features are hard to follow.
- **The index drifts.** On 2026-10-31, `docs/decisions-index.md` listed no ADRs for 0000242, 0000243, or 0000244, and only one of 0000245's two. Its header said it was last updated at 0000241.

The archive holds 126 ADR files.

## Suggested Action

- Make `docs/adr/` the permanent home of every ADR. Name each file `{number}-{slug}.md`, for example `0042-commit-counter-by-path.md`.
- Add a counter file, `docs/adr/.next-id`, that works like `plan/backlog/.next-id`. Reserve ADR numbers with `node ravintio-zero/scripts/reserve-id.mjs --file docs/adr/.next-id`, which already accepts a counter path. Choose the number width at pickup.
- Change the workflow that writes ADRs:
  - The plan skill reserves a number from `docs/adr/.next-id` for each new ADR and commits the counter on its own, as for backlog ids.
  - The ADR is written straight to `docs/adr/`, with status `proposed`. Ship sets it to `accepted`.
  - A superseding ADR names the one it replaces, and the old ADR gets "Superseded by {number}". Nobody deletes an ADR.
  - Ship updates `docs/decisions-index.md` with one row per new ADR, and the archive links to `docs/adr/` instead of holding copies.
- Add a migration in `ravintio-zero/migrations/` that moves existing ADRs:
  - It assigns repo-wide numbers in feature order, then ADR order within a feature.
  - It rewrites "Supersedes {feature} ADR-{n}" references to the new numbers.
  - It replaces archived copies with links, and rebuilds `docs/decisions-index.md` from `docs/adr/`.
  - It sets `docs/adr/.next-id` to one past the highest number.
  - Its `Applies when:` condition covers the pack source too, since this repo holds 126 archived ADRs.
- Fill the index gaps for 0000242 to 0000245 as part of the migration.

## Wanted outcome

Every ADR lives in `docs/adr/` under a unique repo-wide number, and the index lists all of them. Tests check these conditions:

- The plan skill reserves ADR numbers from `docs/adr/.next-id` and never reuses one.
- No ADR file remains under `plan/_archive/*/adr/` after the migration. Each archive links to its ADRs in `docs/adr/`.
- Every file in `docs/adr/` has one row in `docs/decisions-index.md`, and every row points at an existing file.
- Every "Supersedes" and "Superseded by" reference names an existing ADR number.
- Running the migration twice changes nothing the second time.

## Open questions

- Should the migration also recover the ADRs of features 0000001 to 0000029 from git history?
- Should an ADR that belongs to one component live in `src/{component}/docs/adr/` instead, with its own counter?

## Why Deferred

The human asked for it on 2026-10-31. No run is active.
