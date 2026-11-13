---
title: "ADR 003: A single-object hooks value counts as a one-item array"
summary: "Both setup scripts treat a single-object hooks value as a one-item array before the per-command filter, so a stale Planifest command goes."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000039-setup-hardening-release-sizing"
---
# ADR-0135 - A single-object hooks value counts as a one-item array

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000039-setup-hardening-release-sizing
**Component:** planifest-zero
**Date:** 2026-10-19

## Context

ADR-0132 made both scripts filter hook entries one command at a time. It kept an entry with a non-array `hooks` value as it was. A hook entry whose `hooks` value is one object therefore keeps a stale Planifest command, and the hook runs twice after a rerun (backlog 0000114).

## Decision

Before the per-command filter, both scripts treat a single-object `hooks` value as a one-item array. The 0000038 filter then applies:

1. If the command is a Planifest command, the entry goes.
2. If the command is a user command, the entry stays as it was.

Setup keeps the match case-sensitive at a path boundary (0000035 S-004). This refines ADR-0132 for one input shape. Other non-array `hooks` values stay as they were.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep the non-array rule from ADR-0132 | No change | The stale hook stays and runs twice | Does not fix 0000114 |
| Rewrite every single-object value as an array in the saved file | One canonical shape | Changes a user entry that setup does not own | Alters user data without need |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `setup.sh` and `setup.ps1` normalise the `hooks` value in the shared filter. Both suites gain single-object cases |

## Consequences

**Positive:**
- A stale single-object Planifest hook goes, and each hook runs once.
- A single-object user hook stays untouched.

**Negative:**
- The filter has one more input shape to handle in each script.
- Other non-array `hooks` values still stay as they were.

**Risks:**
- Windows PowerShell 5.1 unwraps a one-item array when it rebuilds `entry.hooks` (R-001). Build arrays with `@()` and test on 5.1 in CI.

## Related ADRs

- ADR-0132 - extends (it refines the non-array rule)
- ADR-0134 - related-to (the same hook install step)
- ADR-0133 - related-to (the stack stays the same)

## Supersedes

- None

## Superseded By

- None
