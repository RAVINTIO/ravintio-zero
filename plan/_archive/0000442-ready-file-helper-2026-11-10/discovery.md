---
title: "Discovery - 0000442-ready-file-helper"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000442-ready-file-helper

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000442-ready-file-helper`, cut from `initiative/0000360-backlog-sweep` in the step 25 worktree. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.80.1`. The chart bump for step 25 is `minor`.
- Prior features (`plan/_archive/`): `0000379` built the concurrent driver and the `ready` file. `0000440` made the driver read blocks from the reply.
- Constraining ADRs: ADR-0298 (archive after green CI) and ADR-0299 (the queue reverts a stale version commit).
- Component and data ownership: one component, `ravintio-zero`. Source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- A step writes `$RAVINTIO_INITIATIVE_CONTROL/ready` by hand. Step 9 wrote a timestamp and step 20 left the file empty.
- `readControl` in `initiative-run.mjs` stops the driver on any value that fails `^[1-9][0-9]{0,6}$`. The stop line is `I-C Run: Blocked: step {n} wrote an invalid ready file`.
- `roadmap-standards.md` and the ship skill describe the file in prose. The pack ships no helper.
- Backlog pickup: 0000424, named by the step 25 row. The step row lists no other entry.
- Queue: `/Users/martinmayer/d/ravintio/zero/plan/.initiative-queue/` holds no item for step 25.
- Migration 0009 is pending. It needs a human confirmation, so it stays pending in a step session.
- Chart rows for step 25: schema change `none`, dependency `none`, P1 skip `no`. No `## Decisions` row names step 25.

## Coaching record

None. An initiative step self-confirms its design.
