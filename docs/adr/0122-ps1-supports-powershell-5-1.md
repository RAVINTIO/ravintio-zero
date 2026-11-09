---
title: "ADR 002: setup.ps1 supports Windows PowerShell 5.1"
summary: "setup.ps1 keeps support for Windows PowerShell 5.1, so it uses no PowerShell 7-only feature."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000035-powershell-setup-parity"
---
# ADR-0122 - setup.ps1 supports Windows PowerShell 5.1

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000035-powershell-setup-parity
**Component:** planifest-zero
**Date:** 2026-10-17

## Context

The stack names Windows PowerShell 5.1 and PowerShell 7. Every Windows machine ships with 5.1. `Merge-AllowedTools` calls `ConvertFrom-Json -AsHashtable`, which 5.1 lacks, so setup fails there (backlog 0000105).

## Decision

1. `setup.ps1` keeps support for 5.1.
2. `Merge-AllowedTools` reads `settings.json` as a `PSCustomObject`, the same as the other three writers, and adds `allowedTools` with `Add-Member` when it is absent.
3. `setup.ps1` and `setup/*.ps1` use no `-AsHashtable`, and a suite checks it.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Require PowerShell 7 | One code path | Most Windows users would need an extra install first | Raises the barrier for a one-line fix |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `Merge-AllowedTools` in `setup.ps1` |

## Consequences

**Positive:**
- Setup runs on a fresh Windows machine without an extra install.

**Negative:**
- Without a 5.1 runner, a later PowerShell 7-only feature could slip in. The suite checks only `-AsHashtable`.

**Risks:**
- R-004: `allowedTools` output differs from 0.4.1. All four writers now share one object model.

## Related ADRs

- ADR-0120 - related-to (it named 5.1 in the stack)

## Supersedes

- None

## Superseded By

- None
