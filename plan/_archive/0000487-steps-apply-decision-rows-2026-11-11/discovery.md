---
title: "Discovery - 0000487-steps-apply-decision-rows"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000487-steps-apply-decision-rows

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000487-steps-apply-decision-rows`, cut from `initiative/0000360-backlog-sweep` at `4b19f29a`. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.94.0`. The chart bump for step 45 is `minor`.
- Prior features (`plan/_archive/`): 0000485 is the latest archived run. It added `id-collisions.mjs` to the merge queue.
- Constraining ADRs (unless superseded): ADRs live in `docs/adr/`. The latest is 0312.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- Backlog entry 0000488 (evidence: step 40 activity, 2026-11-10): step 40 ignored the `## Decisions` row for steps 25 to 41. It ran a full baseline and a full suite one after the other. That cost about 30 minutes.
- `roadmap-standards.md` rule `icrun-decision-row` says a matching row is no stop. No step code reads the table, and nothing checks that a step applied a row.
- Rows name steps as `1`, `25-41`, or `1-21`. A reader must expand the ranges.
- Wanted outcome: P0 lists every row that names its step, and the build log records each row applied. A check fails a build log that misses an applicable row.
- Backlog pickup: 0000488-steps-apply-decision-rows, named by the step 45 row. The entry widens no guard. It adds a check and tightens none.
- Decisions rows for step 45: none. No row names step 45.

## Coaching record

None. An initiative step self-confirms its design.
