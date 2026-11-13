---
title: "ADR 002: PowerShell suites use a plain assert helper"
summary: "test-*.ps1 suites use a small helper instead of Pester, and run-tests.sh runs or reports them."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000036-test-runner-coverage"
---
# ADR-0125 - PowerShell suites use a plain assert helper

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000036-test-runner-coverage
**Component:** planifest-zero
**Date:** 2026-10-17

## Context

ADR-0120 deferred Pester and a `pwsh` job to backlog 0000084. Windows PowerShell 5.1 ships Pester 3, while PowerShell 7 users install Pester 5. The two versions use different syntax. The bash suites already use a small `helpers/assert.sh`.

## Decision

1. PowerShell suites are `test-*.ps1` files that use `helpers/assert.ps1`, a helper of the same shape as `assert.sh`. No Pester.
2. `run-tests.sh` runs them with `pwsh` when it exists. Otherwise it prints one skip line with the count. `PLANIFEST_REQUIRE_PWSH=1` turns that skip into a failure.
3. `tests/run-tests.ps1` runs only the PowerShell suites, under whichever host starts it.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Pester 5 | Rich assertions and reports | An install step on 5.1, and a second test style in the repo | Too much for a handful of suites |
| Run `.ps1` suites only from CI | No local change | A maintainer with `pwsh` can't run them with the rest | Local runs matter |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | `tests/run-tests.sh`, new `tests/run-tests.ps1`, new `tests/helpers/assert.ps1` |

## Consequences

**Positive:**
- No new dependency on either host.

**Negative:**
- The helper offers only a few assertions.

**Risks:**
- R-001.

## Related ADRs

- ADR-0120 - related-to (it deferred this decision)
- ADR-0122 - related-to (the suites run on 5.1)

## Supersedes

- None

## Superseded By

- None
