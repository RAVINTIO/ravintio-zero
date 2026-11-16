---
title: "ADR 0349: Duplicate id check in check mode only"
summary: "backlog-index.mjs --check exits 1 on a duplicate id. The generate mode does not, so the merge queue can renumber."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0350 - Duplicate id check in check mode only

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000552-duplicate-backlog-ids
**Component:** ravintio-zero
**File:** `docs/adr/0350-duplicate-id-check-in-check-mode.md`
**Date:** 2026-11-16T04:03:53Z

## Context

Two open entries shared id 0000476 for three days, because no check reports a duplicate id. The merge queue calls the generate mode of `backlog-index.mjs` in `resolveSharedConflicts`, before `renumberCollisions` fixes a duplicate. A generate mode that fails on a duplicate would stop the queue before the renumber.

## Decision

`backlog-index.mjs --check` exits 1 when two entry folders share an id, and names the id and folders on stderr. The generate mode and `--review` ignore duplicates. CI and the pre-push hook run `--check`, so each catches the next duplicate.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Fail in every mode | One rule | Stops the merge queue before it renumbers | It breaks the repair path |
| A new script | Separate concern | A new CI step and file | `--check` already runs in CI and the hook |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One script edit and one test. |

## Consequences

**Positive:**
- CI fails on the next duplicate id.
- The merge queue still renumbers.

**Negative:**
- A duplicate in the generate mode passes silently until `--check` runs.
