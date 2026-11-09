---
title: "ADR 001: The stack stays as it is"
summary: "This feature adds no language, runtime, or dependency. Setup stays in Bash and PowerShell with inline Node JavaScript, and park is Markdown skill text."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000040-setup-json-checks-and-park"
---
# ADR-0137 - The stack stays as it is

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000040-setup-json-checks-and-park
**Component:** planifest-zero
**Date:** 2026-10-21

## Context

`design.md` declares the stack: Bash, PowerShell 5.1 and 7, Node, Markdown skills, and GitHub Actions. Tests are shell and node scripts under `planifest-zero/tests/`. Every change in this feature fits inside that stack.

## Decision

Add no language, runtime, package, or test framework. `setup.sh` keeps using inline `node -e` for JSON. `setup.ps1` uses built-in .NET types and cmdlets only. Park is orchestrator skill text, a template, and calls to `git` and `gh`. CI keeps running the existing suites. See `plan/current/design.md` for the full stack.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Write park as a script | One tested entry point | A new tool to build and maintain, and the human already says "park" to the orchestrator | Out of scope in the brief |
| Add Pester for the `.ps1` suites | Runtime tests for the PowerShell changes | A new test framework for a minor release | Not needed. The existing suites cover the cases |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | None beyond the changes in ADR-0138 to ADR-0141 |

## Consequences

**Positive:**
- No new install requirement for anyone running setup.
- Consumers rerun setup with the tools they already have.

**Negative:**
- Two implementations of the shape check stay in step by hand and by parity tests.
- Park has no script, so its steps depend on the agent following skill text.

**Risks:**
- The PowerShell suites run only in CI where `pwsh` is missing locally. Open a draft PR early so CI runs during implement.

## Related ADRs

- ADR-0138 - related-to (it uses the existing runtimes)
- ADR-0139 - related-to (it uses the existing runtimes)
- ADR-0140 - related-to (it uses the existing runtimes)
- ADR-0141 - related-to (it uses git and `gh` only)

## Supersedes

- None

## Superseded By

- None
