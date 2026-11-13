---
title: "ADR 002: setup.ps1 copies files with System.IO calls"
summary: "The skill and hook copies call System.IO in place of per-file cmdlets, and the SKILL.md rewrite keeps its cmdlets."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000171-faster-setup-ps1-tests"
---
# ADR-0182 - setup.ps1 copies files with System.IO calls

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000171-faster-setup-ps1-tests
**Component:** ravintio-zero
**Date:** 2026-10-25

## Context

A profile showed `Copy-RavintioSkills` takes 427 ms of a 692 ms script body on `pwsh` 7. It writes 544 files, each through a `Copy-Item`, `Test-Path`, or `New-Item` call. A benchmark copied 540 files in 401 ms with `Copy-Item` and in 49 ms with `[System.IO.File]::Copy`. The backlog entry also offered a second route: share one setup run across test cases. Most cases prepare their own `settings.json` first, so few share a starting state.

## Decision

`setup.ps1` gains a helper that copies a file or a folder tree with `System.IO.File` and `System.IO.Directory` calls. `Copy-RavintioSkills` and `Install-EnforcementHooks` use it. The folder copy lists files with `Directory.GetFiles` and `SearchOption.AllDirectories`, so it keeps dot files. The SKILL.md rewrite keeps `Get-Content` and `Set-Content -Encoding UTF8`, so each host keeps its BOM behaviour. Bundle rules and console output stay the same.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Share one setup run per suite | Fewer setup runs | Few cases share a starting state, and consumers gain nothing | Low gain for the test change it needs |
| Move the SKILL.md rewrite to `System.IO` too | A few more milliseconds | Must copy each host's BOM rule by hand | 13 files cost little, and parity risk rises |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `setup.ps1` copy paths change. Consumers get a faster install with the same files. |

## Consequences

**Positive:**
- Every `setup.ps1` run is faster, in CI and for consumers.

**Negative:**
- The helper must match `Copy-Item` behaviour, which a tree test now guards.

**Risks:**
- A path case where the helper and `Copy-Item` differ. The tree test covers fresh and rerun installs.

## Related ADRs

- ADR-0181

## Supersedes

- None

## Superseded By

- None
