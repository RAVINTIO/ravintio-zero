---
title: "ADR 003: Ship uses the replacement branch route for chore"
summary: "The ship skill drops the chore force-with-lease and uses the replacement branch route."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000353-reshape-at-delivery"
---
# ADR-0248 - Ship uses the replacement branch route for chore

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000353-reshape-at-delivery
**Component:** ravintio-zero
**Date:** 2026-11-06

## Context

Ship let `chore/*` squash in place and push with `--force-with-lease`. The human set on 2026-11-01 that nothing force-pushes a branch. The reshape already uses a new branch, so the ship rule is the one place left that allows a rewrite.

## Decision

`## PRs into main` applies the replacement route to `chore/*` and `hotfix/*`: cut a new branch from `origin/main`, build one squashed commit, raise a replacement PR, close the old PR with a link, and delete the old branch. The section no longer names `--force-with-lease`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep the lease for chore | Fewer branches | A rewrite stays allowed | Conflicts with the no-force rule |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | The ship skill text and one test. |

## Consequences

**Positive:**
- One route and no force push anywhere in the pack.

**Negative:**
- A multi-commit chore branch needs a replacement PR.

**Risks:**
- See R-001 to R-005 in the risk register.

## Related ADRs

- ADR-0246 - related

## Supersedes

- None.

## Superseded By

- None.
