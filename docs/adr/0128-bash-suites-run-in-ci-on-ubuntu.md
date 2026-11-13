---
title: "ADR 002: The Bash suites run in CI on Ubuntu"
summary: "A bash-suites job on ubuntu-latest runs run-tests.sh with PLANIFEST_REQUIRE_PWSH=1, a pinned checkout, and contents: read. The validate-telemetry-schema job goes."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000037-self-host-on-planifest-zero"
---
# ADR-0128 - The Bash suites run in CI on Ubuntu

**Skill:** [adr-agent](../../../.claude/skills/planifest-adr-agent/SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Component:** planifest-zero
**Date:** 2026-10-17

## Context

CI runs the PowerShell suites on Windows (ADR-0126). The Bash suites run only locally, so a PR can break one and still show green checks (backlog 0000108). They stayed out of CI because the rename suite fails while `planifest-framework/` exists. ADR-0127 removes that folder. `run-tests.sh` also runs each `.ps1` suite with `pwsh`. If `pwsh` is missing, it skips them, and `PLANIFEST_REQUIRE_PWSH=1` turns that skip into a failure. GitHub's `ubuntu-latest` image ships PowerShell 7 as `pwsh`. The `validate-telemetry-schema` job is the only CI step that reads a secret, and it guards telemetry the product no longer has.

## Decision

1. Add a `bash-suites` job on `ubuntu-latest` that runs `planifest-zero/tests/run-tests.sh` with `PLANIFEST_REQUIRE_PWSH=1`.
2. Pin its checkout to the same v4 commit SHA as the `windows-powershell` job, with `persist-credentials: false`.
3. Give the job `permissions: contents: read`.
4. Remove the `validate-telemetry-schema` job.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Run on a macOS runner | Matches the platform where the suites have run so far | Hides GNU tool differences that Linux users meet | Linux is the wider target |
| Run on Ubuntu without the `pwsh` requirement | Never fails on a missing `pwsh` | A missing `pwsh` skips the `.ps1` suites and still reports green | A silent skip is the gap this job closes |
| Run on Ubuntu with `pwsh` required | Every suite runs, or the job fails | GNU tools can differ from the BSD tools on macOS | Chosen |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | none in the product. The workflow belongs to this repo |

## Consequences

**Positive:**
- A PR that breaks a Bash suite fails CI.
- CI reads no secret once the telemetry job goes.

**Negative:**
- The suites have only run on macOS. A GNU and BSD tool difference could fail a suite on Ubuntu (R-007).
- The job fails until req-004 removes `planifest-framework/`, so req-006 runs last in P3.

**Risks:**
- R-006 and R-007.

## Related ADRs

- ADR-0127 - depends-on (the rename suite passes only after the deletion)

## Supersedes

- None

## Superseded By

- None
