---
title: "ADR 001: The stack stays as it is"
summary: "This feature adds no language, runtime, or dependency. Setup stays in Bash and PowerShell, with inline Node JavaScript for JSON."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000038-setup-hook-filter-fixes"
---
# ADR-0131 - The stack stays as it is

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000038-setup-hook-filter-fixes
**Component:** planifest-zero
**Date:** 2026-10-17

## Context

`design.md` declares the stack: Bash, PowerShell 5.1 and 7, inline Node JavaScript, and GitHub Actions. Tests are Bash suites. Every change in this feature fits inside that stack.

## Decision

Add no language, runtime, package, or test framework. `setup.sh` keeps using inline `node -e` for JSON. `setup.ps1` uses built-in cmdlets only. CI keeps running the existing suites.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Add Pester and a `pwsh` test job for `setup.ps1` | Runtime tests for the PowerShell filter | A new runtime and test framework for a patch release | Deferred to backlog 0000084 |
| Move the filter into one shared Node helper that both scripts call | One implementation of the filter rule | `setup.ps1` would then need Node, which it doesn't need today | Breaks the PowerShell install path |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | None beyond the change in ADR-0132 |

## Consequences

**Positive:**
- No new install requirement for anyone running setup.

**Negative:**
- Two implementations of the filter rule stay in step by hand and by tests.

**Risks:**
- The `.ps1` suite runs only in CI where `pwsh` is missing locally (R-003).

## Related ADRs

- ADR-0132 - related-to (its filter uses the existing runtimes)

## Supersedes

- None

## Superseded By

- None
