---
title: "ADR 0351: Check each phase Start against its first artifact commit"
summary: "Check 10 of build-log-check.mjs fails a phase block whose Start is later than the first commit of that phase's artifacts."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
feature: "0000576-phase-start-time-at-phase-start"
---
# ADR-0351 - Check each phase Start against its first artifact commit

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000576-phase-start-time-at-phase-start
**Component:** ravintio-zero
**File:** `docs/adr/0351-check-phase-start-against-first-commit.md`
**Date:** 2026-11-16T07:07:00Z

## Context

An autonomous run can write a phase block at phase end. Step 4 of an earlier run did so for P1 to P3. The `Start` and `End` times then differed by seconds and the build report showed `not recorded`. Checks 1 to 9 accept such a log.

## Decision

Add check 10 to `build-log-check.mjs`. It finds the commit that added the build log. For each phase it lists later commits that touch that phase's artifact paths. The oldest is the first artifact commit. P2 counts any path outside `plan/` and `docs/`. The check fails the phase when its `Start` is more than one minute later. It skips a phase with no committed artifact, a skipped phase, and a log outside git. The Phase Invocation reference names the check.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Compare Start with the commit that adds the block | No path list | A block written late is also committed late, so it passes | It misses the reported failure |
| Keep the rule in prose | No new code | Step 4 shows the prose alone fails | Nothing would catch a late block |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One new check, one test, and one reference bullet. |

## Consequences

**Positive:**
- A late block write fails ship and names the phase.

**Negative:**
- The path list needs an update when a phase gains a new artifact.
