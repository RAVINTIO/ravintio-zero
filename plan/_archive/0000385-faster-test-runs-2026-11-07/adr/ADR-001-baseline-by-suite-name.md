---
title: "ADR 001: Baseline failures match by suite name"
summary: "The baseline records failed suite file names and P3 compares by name."
status: "accepted"
version: "0.1.0"
---
# ADR-001 - Baseline failures match by suite name

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000385-faster-test-runs
**Component:** ravintio-zero
**Date:** 2026-11-07

## Context

The runner prints the failed suite file names under `Failed suites:`. It does not print stable test ids. The baseline needs a key that survives between two runs.

## Decision

`baseline-failures.mjs` records and compares suite file names. A suite that fails on the base commit is inherited. Any other failed suite is new.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Match individual assertion lines | Finer grain | Output text changes between runs | Unstable key |
| Match the hash of the output | Exact | Any change in output text breaks it | Unstable key |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One new script and one new run artifact |

## Consequences

**Positive:**
- The key exists in the runner output today, so no runner change is needed.

**Negative:**
- A new failure inside an already failing suite looks inherited.

**Risks:**
- The build report lists every inherited suite so a human can review it.

## Related ADRs

- ADR-002 - related-to

## Supersedes

- None

## Superseded By

- None
