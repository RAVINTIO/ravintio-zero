---
title: "ADR 0310: Regenerate in a separate commit after every base merge"
summary: "The queue regenerates shared files after every base merge and commits any change in its own commit before the push."
status: "proposed"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0310 - Regenerate in a separate commit after every base merge

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000481-regenerate-after-every-merge
**Component:** ravintio-zero
**File:** `docs/adr/0310-regenerate-in-a-separate-commit.md`
**Date:** 2026-11-11

## Context

ADR-0302 resolves shared files only when the base merge conflicts. A clean merge on 2026-11-10 left `plan/backlog/index.md` stale and CI failed.

## Decision

After every base merge, clean or resolved, the queue rebuilds the index and checks both counters. It commits any change in a separate commit before the push. If nothing changes, it adds no commit.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Amend the merge commit | One commit | Rewrites a commit that a failed run may have pushed | A rerun then needs a force push |
| Regenerate only on conflict | No change | Leaves the stale index failure | It is the bug |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `shared-files.mjs` gains `regenerateSharedFiles`. `merge-queue.mjs` calls it. |

## Consequences

**Positive:**
- A step PR never stops on a stale generated file.

**Negative:**
- A PR can carry one more commit, and CI runs again on it.

**Risks:**
- A non-deterministic index would add a commit on every run.

## Related ADRs

- ADR-0302 - extends

## Supersedes

None.

## Superseded By

None.
