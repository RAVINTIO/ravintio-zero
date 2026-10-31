---
title: "ADR 001: Clear the environment in the runner"
summary: "The runners clear RAVINTIO_ variables for each suite and check the tree at the end."
status: "active"
version: "0.41.2"
---
# ADR-001 - Clear the environment in the runner

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000315-isolated-test-state
**Component:** ravintio-zero
**Date:** 2026-10-31

## Context

A step session sets `RAVINTIO_INITIATIVE_STEP=1`. A nested runner inherits `RAVINTIO_TEST_QUIET=1`. Each leak failed a suite once. The runner already unsets `RAVINTIO_INITIATIVE_STEP` (0000251), one variable at a time.

## Decision

The runner starts every suite with all `RAVINTIO_*` variables removed, except `RAVINTIO_PWSH` and `RAVINTIO_TIMING_FILE`. It reads its own settings before it clears them. A suite that needs a variable sets it. After the last suite, the runner compares a snapshot of tracked and untracked files with one taken before the first suite.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Unset one variable per incident | No design | Each new variable fails a suite first | Repeats the cause |
| Compare ignored files too | Catches more | Driver logs change during a step | Gives false failures |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Both runners and one test change |

## Consequences

**Positive:**
- The suite gives one result in any session.
- A suite that writes repo state fails the run and names the path.

**Negative:**
- A suite that relied on an inherited variable must set it.

**Risks:**
- The snapshot adds a short delay at start and end.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
