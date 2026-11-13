---
title: "ADR 003: The stack stays as it is"
summary: "This feature adds no language, runtime, or dependency. Setup stays in Bash and PowerShell, with inline Node for JSON."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000034-setup-hardening"
---
# ADR-0120 - The stack stays as it is

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000034-setup-hardening
**Component:** planifest-zero
**Date:** 2026-10-16

## Context

The design declares the stack: Bash 3.2+, Windows PowerShell 5.1 and PowerShell 7, and Node 18+ for inline JSON edits. Tests are Bash suites. Every change in this feature fits inside that stack.

## Decision

Add no language, runtime, package, or test framework. `setup.sh` keeps using inline `node -e` for JSON, and `fs.renameSync` covers ADR-0119. `setup.ps1` uses built-in cmdlets only.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Add Pester and a `pwsh` CI job | Runtime tests for `setup.ps1` | A new runtime and test framework for a patch release | Deferred to backlog 0000084 |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | None beyond the changes in ADR-0118 and ADR-0119 |

## Consequences

**Positive:**
- No new install requirement for anyone running setup.

**Negative:**
- `setup.ps1` stays without runtime tests.

**Risks:**
- None

## Related ADRs

- ADR-0119 - related-to (its Node rename uses the existing runtime)

## Supersedes

- None

## Superseded By

- None
