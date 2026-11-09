---
title: "ADR 003: Move the initiative on activation"
summary: "I-B Activate keeps moving the initiative to plan/current-initiative/initiative.md, a fixed path that carries state across sessions."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000189-name-the-roadmap-initiative"
---
# ADR-0194 - Move the initiative on activation

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000189-name-the-roadmap-initiative
**Component:** ravintio-zero
**Date:** 26 Oct 2026

## Context

A charted initiative lives at `plan/roadmap/{id}-{slug}/`. Today I-B Activate moves it to `plan/current-roadmap/roadmap.md`. The feature renames that path. P0 asked whether to drop the move and keep each initiative in its roadmap folder throughout.

## Decision

Keep the move. I-B Activate cuts `initiative/{id}-{slug}` and moves the initiative to `plan/current-initiative/initiative.md`. A fixed path tells the driver, the hooks, and a fresh session where the active initiative is. A new session needs no search to resume.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep each initiative in `plan/roadmap/{id}-{slug}/` throughout | No move step, and the file keeps one path | Every reader must find the active one among many folders | The human chose the fixed path at P0 because it helps resume state across sessions |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Skills, driver, hooks, and migration 0005 use `plan/current-initiative/` as the single active path. |

## Consequences

**Positive:**
- A session finds the active initiative at one known path.
- "Is an initiative active" becomes a check for one folder.
- Migration 0005 uses the same folder as its stop signal.

**Negative:**
- The initiative's path changes at activation, so links to its charted path break.
- The move is one more step that can fail part way.

**Risks:**
- A partial move leaves the initiative in two places. Each rename lands as one commit, so a rerun finishes the move.

## Related ADRs

- ADR-0192 (stack choice) - related-to. It sets the stack that the activation scripts use.
- ADR-0193 - related-to. Migration 0005 refuses to run while `plan/current-roadmap/` exists.
- ADR-0195 - depends-on. It sets the `initiative` names in the path.
- ADR-0196 - related-to. The guard flags the old `current-roadmap` name.

## Supersedes

- None

## Superseded By

- None
