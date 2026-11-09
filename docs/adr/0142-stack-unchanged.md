---
title: "ADR 001: The stack stays as it is"
summary: "This feature adds no language, runtime, or dependency. Setup stays in Bash and PowerShell with inline Node JavaScript, and park stays a Node script that calls git."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000041-setup-cleanup-and-park-hardening"
---
# ADR-0142 - The stack stays as it is

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000041-setup-cleanup-and-park-hardening
**Component:** planifest-zero
**Date:** 2026-10-22

## Context

`design.md` declares the stack: Bash, PowerShell 5.1 and 7, Node, and GitHub Actions. Tests are shell and node scripts under `planifest-zero/tests/`. Every change in this feature fits inside that stack.

## Decision

Add no language, runtime, package, or test framework. `setup.sh` keeps using inline `node -e` for JSON. `setup.ps1` uses built-in .NET types and cmdlets only. `park.mjs` keeps using Node built-ins and the `git` CLI. CI keeps running the existing suites. See `plan/current/design.md` for the full stack.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Add Pester for the `.ps1` suites | Runtime tests for the PowerShell changes | A new test framework for a release of bug fixes | Not needed. The existing suites cover the cases |
| Share one JSON shape check between both scripts as a Node module | One copy of the rule | `setup.ps1` would gain a Node dependency it does not have today | Breaks the PowerShell-only promise of `setup.ps1` |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | None beyond the changes in ADR-0143 and ADR-0144 and the park fix |

## Consequences

**Positive:**
- No new install requirement for anyone who runs setup.
- Consumers rerun setup with the tools they already have.

**Negative:**
- The two scripts keep two copies of the shape rule, kept in step by parity tests.

**Risks:**
- The PowerShell suites run only in CI, because `pwsh` is missing locally. Push early so CI runs during implement.

## Related ADRs

- ADR-0143 - related-to (it uses the existing runtimes)
- ADR-0144 - related-to (it uses the existing runtimes)

## Supersedes

- None

## Superseded By

- None
