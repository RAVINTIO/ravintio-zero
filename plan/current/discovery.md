---
title: "Discovery - 0000386-unit-dispatch"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000386-unit-dispatch

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000386-unit-dispatch`, cut from `initiative/0000360-backlog-sweep` at `b01e68b1`. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.70.0`
- Prior features (`plan/_archive/`): `0000385-faster-test-runs` added the affected-tests rule and the `Tests run:` line. `0000387-light-discovery-and-audits` added the light track.
- Constraining ADRs (unless superseded): none found that bind the dispatch table or the `Done:` line.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`, owns the skills, standards, and scripts.

## Problem findings

- `ravintio-implement` requires three subagents per requirement. Content units ran the loop inline in several runs and logged a departure each time (0000330).
- The tier table in `ravintio-zero/standards/agent-dispatch-standards.md` assigns a tier by task type. Nothing assigns a tier or effort per unit (0000366).
- The `Done:` line in the build log carries only the unit and a time. `workflow-metrics.mjs` counts only `Rework:`, `Blocked:`, `Requirement change:`, and `Gate revised:`.
- `build-log-check.mjs` checks phase blocks, times, and `Complete:` lines. It reads no `RED:` or `GREEN:` markers.
- Chart row (step 10): classes `content`, `code`, `test`, and `config`. The tier and effort table goes in `agent-dispatch-standards.md`. An inline unit from 0000330 is class `content`. Bump `minor`.
- Repo instructions: `custom-001`, `custom-002`, `custom-004`, and `custom-006` in `ravintio-overrides/instructions/`.
- Queue item `ci-gate-step-10`: CI before ready, restore route after archive, blocks written to the build log. Copied to `plan/current/coordinator-instruction-ci-gate.md`.
- Backlog pickup: entries 0000330 and 0000366, from the chart row.

## Coaching record

The chart accepts the light track and self-confirms the design. No coaching exchange took place.
