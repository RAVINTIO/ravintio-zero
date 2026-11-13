---
title: "ADR 002: Legacy aliases stay through 1.x"
summary: "Two roadmap variables and the old em-dash sentinel stay accepted through 1.x, and the new name wins. Removal is due at 2.0.0. Every other PLANIFEST_ variable renames with no fallback."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000160-ravintio-rebrand"
---
# ADR-0165 - Legacy aliases stay through 1.x

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000160-ravintio-rebrand
**Component:** ravintio-zero
**Date:** 2026-10-24

## Context

The pack reads 26 `PLANIFEST_*` environment variables. Only two face consumers: `PLANIFEST_ROADMAP_MODEL` and `PLANIFEST_ROADMAP_MAX_TURNS`. Consumers set them in shells, CI, and scripts that the pack does not control.

Four variables belong to the test runners. The rest pass values to `node -e` inside setup and scripts. Only the pack's own scripts and tests set those.

The em-dash guard honours the sentinel `planifest-em-dash-allow`. Consumer files can carry that sentinel in text the pack does not own.

## Decision

Three legacy names stay accepted through every 1.x release.

- `PLANIFEST_ROADMAP_MODEL` falls back for `RAVINTIO_ROADMAP_MODEL`.
- `PLANIFEST_ROADMAP_MAX_TURNS` falls back for `RAVINTIO_ROADMAP_MAX_TURNS`.
- The `planifest-em-dash-allow` sentinel works like `ravintio-em-dash-allow`.

When both names are set, the new name wins. The driver does not merge the two. The scripts write no warning when only the old name is set, so existing runs stay quiet.

Version 2.0.0 removes all three fallbacks. The release notes for 1.0.0 name that date.

Every other `PLANIFEST_*` variable renames to `RAVINTIO_*` with no fallback. Only the pack's own scripts and tests set them, so no consumer depends on the old names. The test runners now read `RAVINTIO_TEST_QUIET`, `RAVINTIO_REQUIRE_PWSH`, `RAVINTIO_PWSH`, and `RAVINTIO_PREFLIGHT_ONLY`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Fallbacks for all 26 variables | Maximum compatibility | Keeps 24 names no consumer sets | Dead code with no reader |
| No fallbacks at all | Cleanest code | Breaks consumer CI on upgrade with no warning | Consumers set the two roadmap variables |
| Fallbacks forever | No future breakage | The old brand name never leaves the code | The brand guard needs an end date |
| Warn when the old name is set | Pushes consumers to move | Adds noise to unattended runs | The migration already tells consumers |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | `roadmap-run.mjs` and `em-dash-guard.mjs` read the legacy names. Setup, scripts, and tests use the new names only |

## Consequences

**Positive:**
- Consumer CI and shells keep working after the upgrade.
- The fallback list is short and each entry has a removal version.

**Negative:**
- Three legacy names stay in the code and the brand guard allowlist until 2.0.0.
- Tests must cover both names and the case where both are set.

**Risks:**
- Nobody removes the fallbacks at 2.0.0. The allowlist entries name the removal version so the guard test flags them.

## Related ADRs

- ADR-0164 - extends: the rename map lists these aliases
- ADR-0167 - depends-on: the guard allowlist holds the legacy names

## Supersedes

- None

## Superseded By

- None
