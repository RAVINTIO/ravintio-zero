---
title: "ADR 002: Merge order comes from the chart Version column"
summary: "The reshape and history check sort steps by the Version the queue wrote, not by chart row."
status: "accepted"
version: "0.1.0"
---
# ADR-002 - Merge order comes from the chart Version column

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000378-merge-time-versioning
**Component:** ravintio-zero
**Date:** 2026-11-07

## Context

Steps that run at once can merge in another order than the chart rows. Backlog entry 0000374 asks the scripts to read merge order from the step tags. The queue sets each version in merge order, and tag `v{Version}` marks each merge commit.

## Decision

Both scripts sort steps by the chart `Version` column in ascending semver order. A step with no `Version` keeps its chart position after the versioned steps. The tag is the proof that the version exists, so the reshape still finds the commit by tag.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Read tag creation time | No chart dependency | Clock skew and moved tags | Unreliable |
| Read first-parent log order | Direct | The log is the thing under check | Circular |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `reshape-initiative.mjs` and `check-initiative-history.mjs` sort by `Version` |

## Consequences

**Positive:**
- One source of order that the queue writes.

**Negative:**
- A hand-edited `Version` changes the order.

**Risks:**
- A missing tag still exits 1, as it does today.

## Related ADRs

- ADR-001 - related-to

## Supersedes

- None

## Superseded By

- None
