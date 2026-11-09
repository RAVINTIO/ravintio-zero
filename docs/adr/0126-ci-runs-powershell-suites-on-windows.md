---
title: "ADR 003: CI runs the PowerShell suites on Windows under both hosts"
summary: "A windows-latest job runs run-tests.ps1 with powershell and with pwsh. Bash suites stay out of CI for now."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000036-test-runner-coverage"
---
# ADR-0126 - CI runs the PowerShell suites on Windows under both hosts

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000036-test-runner-coverage
**Component:** planifest-zero
**Date:** 2026-10-17

## Context

No machine available to the pipeline has PowerShell. `windows-latest` runners have Windows PowerShell 5.1 and PowerShell 7. CI runs no tests today. The bash suites include the rename suite, which fails while `planifest-framework/` exists (backlog 0000097).

## Decision

1. A `windows-powershell` job runs `tests/run-tests.ps1` once with `powershell` and once with `pwsh`.
2. The job has `permissions: contents: read` and no secrets.
3. Bash suites stay out of CI until backlog 0000097 lands, so the new job can be green.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Also run `pwsh` on `ubuntu-latest` | Cheaper, and covers Linux | `setup.ps1` targets Windows. A Linux leg tests the wrong platform | Windows is the target |
| Run the bash suites in CI now | Full coverage | Red on every PR until 0000097 | A permanently red job gets ignored |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | none in the product. The workflow belongs to this repo |

## Consequences

**Positive:**
- `setup.ps1` runs under test on both hosts on every PR.

**Negative:**
- Bash suites still run only locally.

**Risks:**
- R-004.

## Related ADRs

- ADR-0125 - related-to (the job runs its suites)

## Supersedes

- None

## Superseded By

- None
