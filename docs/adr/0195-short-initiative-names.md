---
title: "ADR 004: Short initiative names"
summary: "Names use the short form initiative, with I-A to I-E prefixes. Fixed names and history keep their old spelling."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000189-name-the-roadmap-initiative"
---
# ADR-0195 - Short initiative names

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000189-name-the-roadmap-initiative
**Component:** ravintio-zero
**Date:** 26 Oct 2026

## Context

The design's Names table renames files, the branch pattern, scripts, environment variables, and telemetry. P0 had to pick a form for those names. The stage prefixes `R-A` to `R-E` also needed a decision.

## Decision

Use the short form "initiative" in file, branch, script, environment variable, and telemetry names. Examples are `initiative/{id}-{slug}`, `initiative-run.mjs`, `RAVINTIO_INITIATIVE_MODEL`, and `work.kind=initiative`. Use the prefixes `I-A Chart:`, `I-B Activate:`, `I-C Run:`, `I-D Advance:`, and `I-E Delivery:`.

These names stay unchanged:

- `roadmap-standards.md`, because the standard covers the roadmap as a whole.
- `ravintio.step`.
- Historical test file names.
- `plan/_archive/` and `plan/changelog/`.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Long form `roadmap-initiative` in names | Names show the parent term | Longer branch, file, and variable names | The human chose the short form at P0 |
| Keep `R-A` to `R-E` prefixes | No change to stop lines | The prefix names the roadmap, not the initiative | The human chose `I-A` to `I-E` at P0 |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Skills, standards, templates, scripts, hooks, tests, the CI template, and docs use the new names. |

## Consequences

**Positive:**
- Each name says what it holds.
- Names stay short in branches and variables.
- Historical records stay accurate.

**Negative:**
- The word "roadmap" survives in `roadmap-standards.md` and `plan/roadmap/`, so a reader must learn which uses the pack intends.
- Old test files keep old names, so a search for them finds old terms.

**Risks:**
- A missed reference breaks the driver or `merge-guard` at the next activation. The search test in ADR-0196 and a driver dry run reduce this risk.

## Related ADRs

- ADR-0192 (stack choice) - related-to. It sets the stack where these names appear.
- ADR-0193 - extends. Migration 0005 and the old-variable stop apply these names.
- ADR-0194 - related-to. The fixed activation path uses these names.
- ADR-0196 - related-to. The guard enforces these names.

## Supersedes

- None

## Superseded By

- None
