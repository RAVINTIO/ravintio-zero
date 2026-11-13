---
title: "ADR 002: Clean break with a migration"
summary: "The rename ships with no aliases. Migration 0005 moves consumer files, and the driver stops on any old variable."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000189-name-the-roadmap-initiative"
---
# ADR-0193 - Clean break with a migration

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000189-name-the-roadmap-initiative
**Component:** ravintio-zero
**Date:** 26 Oct 2026

## Context

The feature renames the roadmap initiative's files, branch pattern, log folder, and environment variables. The driver today reads `RAVINTIO_ROADMAP_MODEL` and `RAVINTIO_ROADMAP_MAX_TURNS`. It also falls back to `PLANIFEST_ROADMAP_*` through `legacyEnv`. That fallback was due to go at 1.0.0 (ADR-0165). Migration 0004 shows the pattern for a consumer move. This repo is the only consumer today.

## Decision

Rename with no aliases. Migration `0005-initiative-rename.md` moves what setup does not:

- Each `plan/roadmap/{id}-{slug}/roadmap.md` becomes `initiative.md`.
- The CI pattern `roadmap/**` becomes `initiative/**`.
- `plan/.roadmap-logs/` becomes `plan/.initiative-logs/`.

The helper refuses to run while `plan/current-roadmap/` exists. A rerun changes nothing.

The driver reads only `RAVINTIO_INITIATIVE_MODEL` and `RAVINTIO_INITIATIVE_MAX_TURNS`. If an old `RAVINTIO_ROADMAP_*` variable is set, the driver stops and names the replacement. This feature also removes the `PLANIFEST_ROADMAP_*` fallback. Those variables stop the driver in the same way.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep old names as aliases | Consumers upgrade with no action | Two names for one thing, so the glossary cannot settle on one | The human chose a clean break at P0, and this repo is the only consumer |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Adds migration 0005 with Bash and PowerShell helpers. Removes `legacyEnv` and the `PLANIFEST_ROADMAP_*` fallback from the driver. |

## Consequences

**Positive:**
- Each thing has one name, so the glossary and the code agree.
- The driver loses its fallback code.
- A maintainer with a stale variable gets a stop line that names the fix.

**Negative:**
- A consumer must run migration 0005 and rename any exported variable.
- Anyone still on a `PLANIFEST_ROADMAP_*` variable gets a stop line in place of a silent fallback.

**Risks:**
- A consumer upgrades with an initiative active. The migration refuses to run, so the consumer must finish or park the initiative first.
- A shell profile or CI secret still exports an old variable. The driver stops at start, so the failure is early and visible.

## Related ADRs

- ADR-0192 (stack choice) - related-to. It sets the stack (Markdown, Node.js ESM, Bash, PowerShell) that the helpers use.
- ADR-0194 - related-to. It fixes the activation path that the migration refuses to touch.
- ADR-0195 - depends-on. It sets the new names that the migration applies.
- ADR-0196 - related-to. It guards against old names returning, apart from the allowlisted migration files.

## Supersedes

- None. The ADR-0165 plan to drop the fallback at 1.0.0 now happens in this feature.

## Superseded By

- None
