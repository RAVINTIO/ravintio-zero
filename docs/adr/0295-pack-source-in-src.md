---
title: "ADR 0295: Pack source in src"
summary: "The pack source lives at src/ravintio-zero/. The root ravintio-zero/ is a plain installed copy with a sync script."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0295 - Pack source in src

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000397-pack-source-in-src
**Component:** ravintio-zero
**File:** `docs/adr/0295-pack-source-in-src.md`
**Date:** 2026-11-09T21:42:04Z

## Context

In this repo, `ravintio-zero/` is both the pack source and the pack that hooks, the driver, and skills run. A source edit changes the running pack at once. Consumer repos install the pack at `ravintio-zero/` and keep that path.

## Decision

The source moves to `src/ravintio-zero/` in a pure `git mv` commit, so `git log --follow` keeps history. A second commit copies the source back to `ravintio-zero/` as plain files. `scripts/sync-installed.mjs` refreshes the copy and checks parity. Tests find the repo with `git rev-parse --show-toplevel` and the pack from their own location, so one file passes from both folders. Every guard that covers `ravintio-zero/` also covers `src/ravintio-zero/`, with no new allowed form.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Symlink `ravintio-zero` to the source | No second copy | A source edit still changes the running pack | The chart rules out a symlink |
| Keep one folder | No move | The repo cannot develop the pack as a consumer uses it | Backlog 0000396 asks for the move |
| Separate repo for the source | Full isolation | Breaks one-repo history and CI | Too large for one step |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | The source path changes. The installed path stays. |

## Consequences

**Positive:**
- A source edit no longer changes the running pack until a refresh.
- The repo layout matches a consumer repo.

**Negative:**
- Two copies exist and can drift. A parity check catches drift.
- Every pack edit needs a refresh commit.

**Risks:**
- A guard misses the new path.

## Related ADRs

- None.

## Supersedes

- None.
