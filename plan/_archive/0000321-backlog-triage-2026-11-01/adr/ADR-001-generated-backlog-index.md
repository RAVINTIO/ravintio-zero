---
title: "ADR 001: generated backlog index checked in CI"
summary: "The backlog index is a tracked file that a script generates and CI compares with a fresh run."
status: "accepted"
version: "0.1.0"
---
# ADR-001 - Generated backlog index checked in CI

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000321-backlog-triage
**Component:** ravintio-zero
**Date:** 2026-11-01

## Context

The backlog holds 59 entries in one folder each, and nothing lists them together. Priority and theme live in each entry's frontmatter, so any list must come from the entries. A hand-edited list drifts from the entries.

## Decision

Generate `plan/backlog/index.md` with `ravintio-zero/scripts/backlog-index.mjs` and commit it. CI runs the script with `--check` and fails when the committed file differs from a fresh run. Entries stay the single source of truth. The review age lives in `product.yml` as `backlogReviewDays`, so each repo sets its own.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Generate the index only at P0 | No tracked file | A developer outside P0 sees nothing | Fails the at-a-glance outcome |
| Hand-maintained index | No script | Drifts from the entries | Same defect as today |
| Hard-code the review age | No config | Every repo gets 5 days | The human wants a per-repo setting |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | New script, template fields, CI step, pickup text, migration 0007 |

## Consequences

**Positive:**
- A developer reads the whole backlog in one file.
- CI blocks a stale index from landing.

**Negative:**
- Every entry change needs an index regeneration in the same commit.
- A concurrent branch can conflict on `index.md`. The author regenerates it.
