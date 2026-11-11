---
title: "Discovery - 0000448-driver-runs-approved-setup-command"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000448-driver-runs-approved-setup-command

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000448-driver-runs-approved-setup-command`, cut from `initiative/0000360-backlog-sweep` at `55a758ff`. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.91.0`. The chart bump for step 28 is `minor`.
- Prior features (`plan/_archive/`): 0000446 made the driver merge ready PRs after a stop. 0000373 added the `Setup:` stop.
- Constraining ADRs (unless superseded): ADRs live in `docs/adr/`. The latest is 0309.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- Backlog entry 0000427 (evidence row 18 of the initiative 0000360 retrospective): four steps changed hooks, skills, or setup. Each stopped the driver with `Setup:` for the same approved command. Each stop needed a coordinator restart.
- `initiative-run.mjs` throws a `Stop` in the serial path (`main`). It sets a stop in the concurrent path in `restartLine`, `queueTask`, and the last-merge check. It never reads a `Confirmation:` row.
- The chart holds the row: `1-21 | Confirmation: setup rerun at each Setup: stop | Run the exact command ravintio-zero/setup.sh claude-code --strict-orchestrator`. The step 28 row in `## Decisions` records the human's approval on 2026-11-10.
- The driver never updates the main working tree, so the installed pack files can lag the initiative ref.
- Wanted outcome: the driver runs the exact `Confirmation:` command at a `Setup:` stop and continues. A missing or different command still stops.
- Backlog pickup: 0000427, named by the step 28 row. The entry widens no guard.
- Queue: no item names step 28.
- Migration 0009 stays pending. Its migrator needs a y/n answer and a step session has no human.

## Coaching record

None. An initiative step self-confirms its design.
