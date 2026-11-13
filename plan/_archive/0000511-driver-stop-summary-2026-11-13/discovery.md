---
title: "Discovery - 0000511-driver-stop-summary"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000511-driver-stop-summary

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `src/` holds the component. This is the only signal. |
| Git pre-flight | Branch `feat/0000511-driver-stop-summary`, cut by the driver from the initiative branch. Clean tree. It holds one earlier commit that files backlog entry 0000532. |
| Skills inbox | empty |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.111.0`
- Prior features (`plan/_archive/`): step 56 (0000509, driver clears ready files of merged steps) is the closest driver change.
- Constraining ADRs: ADR-0340 (ready file clearing), ADR-0327 (planned restart exit code), ADR-0339 (hook check wiring).
- Component map: one component, `ravintio-zero`. Source in `src/ravintio-zero/`. The installed copy `ravintio-zero/` comes from `sync-installed.mjs`.

## Findings for this step

- Backlog entry 0000512 states the problem. At each driver stop, the human reads many lines to learn what happened and whether they must act. The driver prints one state line per step.
- Every driver line goes through `out()` in `src/ravintio-zero/scripts/initiative-run.mjs`. Every end of the run passes the two handlers at the bottom of the file, and the signal handler.
- The lines that name a merge (`I-D Advance: Complete: step {n} merged`) and a self-fix (`Cleared:`, a recovered ready file, the approved setup run, a dead lock taken) already exist.
- Docs that describe the rule: the header comment of `initiative-run.mjs` and the "Concurrent steps" section of `roadmap-standards.md`.
- Schema, dependency, and guard checks: the step changes no schema, adds no dependency, and widens no hook guard.
- Migration check: skipped in this step session. The step has no human to confirm one.
