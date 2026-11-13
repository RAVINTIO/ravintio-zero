---
title: "ADR 001: Measure CLAUDE.md without the override block"
summary: "The size cap test strips the override block from the repo CLAUDE.md instead of reading the boot template."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000242-size-cap-excludes-overrides"
---
# ADR-0225 - Measure CLAUDE.md without the override block

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000242-size-cap-excludes-overrides
**Component:** ravintio-zero
**Date:** 2026-10-28

## Context

The size cap test adds `CLAUDE.md` to `SKILL.md`. `CLAUDE.md` holds every override, so each new override raises the sum. The stack is Bash tests, per the design.

## Decision

The test strips the lines from the `ravintio-overrides:instructions:start` marker to the `end` marker and counts what remains. The cap is 32,800 bytes, which is the pack-only sum of 32,697 bytes plus 103 bytes of margin.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Read `standard-boot.md` directly | Exact figure | Stops checking the generated file | A setup change that grows `CLAUDE.md` would pass |
| Keep counting overrides and raise the cap | No test change | Every override breaks a pack test again | The fault in entry 0000214 stays |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One test file |

## Consequences

**Positive:**
- An override never changes the result.
- A pack change that grows the boot file still fails.

**Negative:**
- The test depends on the two marker strings.

**Risks:**
- See R-001 and R-002.

## Related ADRs

- None

## Supersedes

- None

## Superseded By

- None
