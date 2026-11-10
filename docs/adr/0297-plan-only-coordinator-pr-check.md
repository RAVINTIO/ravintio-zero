---
title: "ADR 0297: Plan-only coordinator PRs skip the full suite"
summary: "A coordinator PR skips the full suite only when every changed file since the last green run is under plan/. It runs the plan format checks instead."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0297 - Plan-only coordinator PRs skip the full suite

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000399-smoother-activation
**Component:** ravintio-zero
**File:** `docs/adr/0297-plan-only-coordinator-pr-check.md`
**Date:** 2026-11-10T00:49:24Z

## Context

The full local suite takes over 10 minutes. It ran twice during activation of 0000360 because a chart edit landed after the first run. A chart edit cannot break code.

## Decision

A coordinator PR skips the full suite only when every changed file since the last green run is under `plan/`. `coordinator-pr-check.mjs` takes a base commit, prints `plan-only` after it runs the plan format checks, and prints `full-suite` when any other file changed. The initiative skill states the rule. Any file outside `plan/` forces the full suite.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Always run the full suite | Safest | Wastes 10 minutes per chart edit | The brief asks to skip it |
| Skip for any docs change | Faster | Docs tests can fail | Only `plan/` is safe |
| Speed up the suite | Helps every run | Large separate work | Out of scope |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Gains `coordinator-pr-check.mjs` and a skill rule |

## Consequences

**Positive:**
- A plan-only PR skips about 10 minutes of waiting.

**Negative:**
- A plan file that a test reads could break the suite unseen.

**Risks:**
- The plan format checks may miss a rule that the suite covers. CI still runs on the PR.

## Related ADRs

- ADR-0296 - related-to

## Supersedes

- None

## Superseded By

- None
