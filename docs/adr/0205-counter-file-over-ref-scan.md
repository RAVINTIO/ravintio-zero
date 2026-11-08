---
title: "ADR-0205 - A counter file in place of a scan of every ref"
status: "accepted"
component: "ravintio-zero"
feature: "0000199-reserve-ids-from-counter"
---
# ADR-0205 - A counter file in place of a scan of every ref

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000199-reserve-ids-from-counter
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The folder scan misses ids on other branches, ids that pickup deleted, and ids that a copy brings from another repo. Backlog id 0000026 appears twice in each repo's history. The human on the loop chose a counter over a scan of every ref, because a counter needs no search.

## Decision

`plan/backlog/.next-id` holds the next free id. `reserve-id.mjs` takes an exclusive lock with `open(..., 'wx')` on `.next-id.lock`, reads the number, writes the new number to a temporary file, renames it over the counter, and releases the lock. Backlog, feature, and initiative ids all reserve from it. A copied entry reserves a local id and names its source id. `--init` bootstraps a repo that has no counter with one scan.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Scan every git ref for the highest id | No new file | Slow, and it misses a peer session that has not pushed | The human chose the counter |
| Random or time-based ids | No shared state | Breaks the zero-padded sequence and the sort order | The sequence is a pack convention |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | A new script and a tracked counter file |

## Consequences

**Positive:**
- A reservation is one atomic step, and an id is never reused.

**Negative:**
- Two branches that reserve conflict on one line of `.next-id`.

**Risks:**
- A lost conflict resolution reuses ids. The docs say to keep the higher value and renumber the later branch.

## Related ADRs

- ADR-0204

## Supersedes

None.

## Superseded By

None.
