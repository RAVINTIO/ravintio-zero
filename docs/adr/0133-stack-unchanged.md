---
title: "ADR 001: The stack stays as it is"
summary: "This feature adds no language, runtime, or dependency. Setup stays in Bash and PowerShell, with inline Node JavaScript for JSON."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000039-setup-hardening-release-sizing"
---
# ADR-0133 - The stack stays as it is

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000039-setup-hardening-release-sizing
**Component:** planifest-zero
**Date:** 2026-10-19

## Context

`design.md` declares the stack: Bash, PowerShell 5.1 and 7, inline Node JavaScript, Markdown skills, and GitHub Actions. Tests are Bash suites and `.ps1` suites. Every change in this feature fits inside that stack.

## Decision

Add no language, runtime, package, or test framework. `setup.sh` keeps using inline `node -e` for JSON. `setup.ps1` uses built-in cmdlets only. The release-size setting is plain text in a skill and a YAML field. CI keeps running the existing suites.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Add a script that counts touched files and sizes a release | Removes the estimate at discovery | A new tool to build and maintain | Out of scope in the brief. Discovery estimates the class |
| Add Pester for the `.ps1` suites | Runtime tests for the PowerShell changes | A new test framework for a minor release | Not needed. The existing `.ps1` suites cover the cases |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | None beyond the changes in ADR-0134, ADR-0135, and ADR-0136 |

## Consequences

**Positive:**
- No new install requirement for anyone running setup.
- Consumers rerun setup with the tools they already have.

**Negative:**
- Two implementations of the hook rules stay in step by hand and by tests.
- Discovery keeps estimating file counts, so a class can be wrong.

**Risks:**
- The `.ps1` suites run only in CI where `pwsh` is missing locally (R-003). Open a draft PR early so CI runs during implement.

## Related ADRs

- ADR-0134 - related-to (it uses the existing runtimes)
- ADR-0135 - related-to (it uses the existing runtimes)
- ADR-0136 - related-to (it adds a field and no tool)

## Supersedes

- None

## Superseded By

- None
