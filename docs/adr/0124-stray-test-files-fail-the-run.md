---
title: "ADR 001: Stray test files fail the run"
summary: "run-tests.sh names every file under tests/ that is neither a suite nor a known non-suite, and exits 1."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000036-test-runner-coverage"
---
# ADR-0124 - Stray test files fail the run

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000036-test-runner-coverage
**Component:** planifest-zero
**Date:** 2026-10-17

## Context

`run-tests.sh` runs what its glob finds and reports only that. A file that misses the glob never runs and is never mentioned (backlog 0000084). This hid `test_setup.sh` through feature 0000030.

## Decision

1. Before the suites run, `run-tests.sh` lists every file under `tests/`.
2. Suites and an allowlist of known non-suites pass. The allowlist is one array in `run-tests.sh`, with a comment saying why each entry is there.
3. Each other file prints `Undiscovered file: <path>`. The suites still run, and the run exits 1.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Warn without failing | No surprise red runs | A warning scrolls past, which is how the gap stayed hidden | Fails the goal |
| Stop before any suite runs | Fast feedback | Hides every other result behind one stray file | Running the suites costs little |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `tests/run-tests.sh` |

## Consequences

**Positive:**
- A misnamed suite fails on its first run.

**Negative:**
- A new helper file needs an allowlist entry.

**Risks:**
- R-002.

## Related ADRs

- ADR-0125 - related-to (it adds `.ps1` suites to the suite rule)

## Supersedes

- None

## Superseded By

- None
