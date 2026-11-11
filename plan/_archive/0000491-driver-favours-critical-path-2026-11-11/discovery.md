---
title: "Discovery - 0000491-driver-favours-critical-path"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000491-driver-favours-critical-path

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000491-driver-favours-critical-path`, cut from `initiative/0000360-backlog-sweep` at `2bc29f6f`. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.100.0`. The chart bump for step 47 is `minor`.
- Prior features (`plan/_archive/`): 0000489 is the latest archived run for this initiative. It added the Question check.
- Constraining ADRs (unless superseded): ADRs live in `docs/adr/`. The next number is 0319.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- Backlog entry 0000492 (evidence row 29 in `plan/current-initiative/coordinator-evidence.md`): the driver fills a free slot with any step that can start. On 2026-11-10 the driver lane, steps 24 to 29 then 41, waited while steps in shorter lanes ran, so the initiative took hours longer.
- `readySteps(steps, states)` in `initiative-chart.mjs` returns the startable steps in chart order. `startable()` in `initiative-run.mjs` takes the first `free` of them after the resumes.
- The chain behind a step holds every step that waits on it. A step waits through an `After` list, or because it shares the lane and comes later.
- Wanted outcome: when several steps can start, the one with the longest chain behind it starts first. Ties keep chart order.
- The entry widens no guard.
- Decisions rows for step 47: none. No row names step 47.
- Pending migration 0009 (ADRs in `docs/adr/`): `Safe to skip: Yes`, and a step session has no human for its `Proceed? (y/n)`. It stays pending, as in steps 28, 40, and 46.

## Coaching record

None. An initiative step self-confirms its design.
