---
title: "ADR 0296: Activate script runs existing commands only"
summary: "One script runs I-B Activate with existing git and gh commands, resumes on rerun, and prints the driver and watcher commands."
status: "accepted"
component: "ravintio-zero"
version: "0.1.0"
---
# ADR-0296 - Activate script runs existing commands only

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000399-smoother-activation
**Component:** ravintio-zero
**File:** `docs/adr/0296-activate-script-existing-commands.md`
**Date:** 2026-11-10T00:49:24Z

## Context

I-B Activate takes many manual commands and several questions. The human wants one confirmation. Guards forbid new allowed forms for `git` and `gh`. The skill runs in a host that owns background tasks.

## Decision

`initiative-activate.mjs` runs only `git` and `gh` commands that guards already allow. It stops after the branch push and resumes at the PR step on rerun. It merges only the coordinator PR into `initiative/*`. It prints the driver and watcher commands and does not start them, because the host runs background tasks.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Script starts the driver and watcher | One step fewer for the human | The script must detach processes itself | The host owns background tasks |
| Add new allowed guard forms | Fewer constraints on the script | Widens a fail-closed guard | The design forbids it |
| Keep manual activation | No new code | The human repeats the slow steps | The brief asks for one confirmation |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Gains `initiative-activate.mjs` and a skill step that calls it |

## Consequences

**Positive:**
- Activation needs one confirmation and no guard change.
- A rerun resumes after a push failure.

**Negative:**
- The skill must start the driver and watcher from the printed commands.

**Risks:**
- A half-finished run leaves a pushed branch. The resume check covers it.

## Related ADRs

- ADR-0297 - related-to

## Supersedes

- None

## Superseded By

- None
