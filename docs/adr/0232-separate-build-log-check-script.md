---
title: "ADR 001: the build log check is its own script"
summary: "build-log-check.mjs checks the build log at ship, apart from consistency-check.mjs, which checks the plan at P1."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000248-ship-merge-and-wall-clocks"
---
# ADR-0232 - the build log check is its own script

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000248-ship-merge-and-wall-clocks
**Component:** ravintio-zero
**Date:** 2026-10-28

## Context

Entry 0000232 offers two places for the check: a new section in `consistency-check.mjs`, or a ship step that runs a check before Archive. `consistency-check.mjs` runs at P1 over plan artifacts. At P1 the P2 to P4 phase blocks do not exist, so a build log check there would fail every run.

## Decision

Add `ravintio-zero/scripts/build-log-check.mjs`. Ship Step 3 runs it after the P4 `End` and `Wall clock` have values and before Archive. It takes the build log path as its one argument.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| New check in `consistency-check.mjs` | One script for all checks | It runs at P1, before the blocks exist, and needs a mode flag | The two checks have different moments and inputs |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One script, one skill step, one template note, one test |

## Consequences

**Positive:**
- The check runs at the one moment the build log is complete.
- `consistency-check.mjs` keeps its single purpose.

**Negative:**
- The pack holds one more script to maintain.

**Risks:**
- A resumed run edits the log after the check. Ship reruns the check on the file as it stands.

## Related ADRs

- none

## Supersedes

- none

## Superseded By

- none
