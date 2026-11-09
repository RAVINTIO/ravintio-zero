---
title: "ADR 001: The stack stays as it is"
summary: "This feature adds no language, runtime, or dependency. Skills stay Markdown, scripts stay Bash and PowerShell, and tests stay shell and node scripts."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000042-autonomous-mode-and-prefixes"
---
# ADR-0145 - The stack stays as it is

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Component:** planifest-zero
**Date:** 2026-10-23

## Context

`design.md` declares the stack: Markdown skills, Bash, PowerShell 5.1 and 7, Node, and GitHub Actions. Tests are shell and node scripts under `planifest-zero/tests/`. This feature changes run modes, phase numbers, and wording. Every change fits inside that stack.

## Decision

Add no language, runtime, package, or test framework. The new run-mode, phase-number, and wording checks are shell or node test scripts in `planifest-zero/tests/`. The setup scripts keep their current runtimes. CI keeps running the existing suites. See `plan/current/design.md` for the full stack.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Add a Markdown linter for the wording check | Reuses a maintained rule engine | A new dependency for one grep with an allowlist | A shell test does the same job with no install step |
| Write the wording check in a new language | Richer parsing of prose | Every contributor needs another runtime | The grep needs no parsing |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | None beyond the changes in ADR-0146 |

## Consequences

**Positive:**
- No new install requirement for anyone who runs setup.
- The new tests run in the existing `run-tests.sh` and `run-tests.ps1` runners.

**Negative:**
- The wording test relies on an allowlist of generic uses, which a maintainer must keep current.

**Risks:**
- The PowerShell suites run only in CI when `pwsh` is missing locally. Push early so CI runs during P2.

## Related ADRs

- ADR-0146 - related-to (it uses the existing stack)

## Supersedes

- None

## Superseded By

- None
