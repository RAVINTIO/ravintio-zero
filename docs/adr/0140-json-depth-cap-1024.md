---
title: "ADR 004: Test-JsonText caps depth at 1024 and runs in linear time"
summary: "Test-JsonText tracks depth with an integer and a typed character stack, and it fails at depth 1024 with the shared line. Cost grows linearly with input length."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000040-setup-json-checks-and-park"
---
# ADR-0140 - Test-JsonText caps depth at 1024 and runs in linear time

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000040-setup-json-checks-and-park
**Component:** planifest-zero
**Date:** 2026-10-21

## Context

`Test-JsonText` in `setup.ps1` checks strict JSON before `ConvertFrom-Json` runs. It tracks nesting in a string and grows it with `$stack += '{'`. Each append copies the string, so cost grows with the square of the depth (backlog 0000122).

`ConvertFrom-Json` caps nesting depth. A file deeper than the cap can never parse, so a deeper check buys nothing.

## Decision

`Test-JsonText` tracks depth with an integer and a `[System.Collections.Generic.Stack[char]]`. It fails when depth reaches 1024. It prints the shared line from ADR-0138 and exits 1. Each push and pop costs constant time, so cost grows linearly with input length. The latency target is under 5 seconds for 100,000 levels of nesting.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Integer and stack only, with no cap | Linear cost with no new failure | A file that cannot parse later still passes this check, and the failure shows the wrong message | Deep files can never succeed |
| Keep the string stack | No change | Quadratic cost on deep input | Does not fix 0000122 |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `Test-JsonText` in `setup.ps1` changes. The suite gains a deep-nesting case with a time bound |

## Consequences

**Positive:**
- Very deep input fails fast instead of slowing with the square of the depth.
- The failure message names the real fault.

**Negative:**
- `setup.ps1` rejects a file that node would read, if nesting passes 1024.
- The cap is a fixed number that a maintainer must keep in step with PowerShell.

**Risks:**
- A future PowerShell version might change its own depth limit. The 1024 cap then needs a review.

## Related ADRs

- ADR-0138 - extends (it uses the same shared line)
- ADR-0134 - related-to (strict JSON check before `ConvertFrom-Json`)

## Supersedes

- None

## Superseded By

- None
