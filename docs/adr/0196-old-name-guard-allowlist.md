---
title: "ADR 005: Old-name guard with a file allowlist"
summary: "A Bash search test fails when an old name appears in a tracked file outside an allowlist of exact paths."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000189-name-the-roadmap-initiative"
---
# ADR-0196 - Old-name guard with a file allowlist

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000189-name-the-roadmap-initiative
**Component:** ravintio-zero
**Date:** 26 Oct 2026

## Context

A rename across skills, scripts, hooks, tests, and docs often stays half done. A later edit can also bring an old name back. The design sets a target of 0 old names outside the allowlist. Some files must keep old names, such as the migration 0005 files, historical tests, and the driver's old-variable check.

## Decision

Add `ravintio-zero/tests/test-0000189-req-007-old-name-guard.sh`. It searches tracked files for each old name and prints each hit with file and line. It fails on any hit outside the allowlist.

The allowlist names exact file paths. Three folders are the only entries that cover a whole tree: `plan/_archive/`, `plan/changelog/`, and `plan/current/`. The first two hold history that this feature must not edit. `plan/current/` holds a run's working state, and ship moves it to `plan/_archive/`. P2 added it, because this run's own plan artifacts name every old name.

Amended after P4: ship archived `plan/current/`, so the guard no longer needs it. The allowlist now holds two folders, `plan/_archive/` and `plan/changelog/`. A future run's plan files get the same check as the rest of the repo.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Folder-level allowlist | Short list | One entry hides every miss under it | A miss in an allowed folder would pass |
| No guard | No test to maintain | Regressions creep back | The design requires a measured result of 0 old names |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Adds one Bash test that the existing runner runs on Linux, macOS, and Windows. |

## Consequences

**Positive:**
- A missed or returning old name fails CI with a file and line.
- Exact paths make each exception a visible review decision.

**Negative:**
- Each new legitimate use of an old name needs an allowlist edit.
- The old-name list must track the design's Names table.

**Risks:**
- The old-name list drifts from the Names table. The test plants a name in a temporary copy to prove the search still fails.
- The Bash search behaves differently on Windows. CI runs the test on all three systems.

## Related ADRs

- ADR-0192 (stack choice) - related-to. It sets Bash 3.2 as part of the stack, so the test avoids newer features.
- ADR-0193 - related-to. The migration 0005 files and the driver's old-variable check sit on the allowlist.
- ADR-0194 - related-to. The guard flags `current-roadmap`.
- ADR-0195 - depends-on. It sets the names that the guard enforces.

## Supersedes

- None

## Superseded By

- None
