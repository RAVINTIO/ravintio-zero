---
title: "Discovery - 0000575-build-log-marker-helper"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000575-build-log-marker-helper

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000575-build-log-marker-helper`, cut by the driver from the initiative branch |
| Skills inbox | empty |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.134.0`
- Prior features (`plan/_archive/`): see the archive folder. Step 13 (0000557) merged last.
- Constraining ADRs: none found for this change.
- Component / data-ownership map: component `ravintio-zero` in `src/ravintio-zero/`, mirrored to `ravintio-zero/`.

## Step findings

- Entry 0000524 asks for `ravintio-zero/scripts/build-log-mark.mjs`. It takes a marker kind and a unit, reads the clock, and appends the line to `plan/current/build-log.md`.
- The implement skill names the script for each `RED:`, `GREEN:`, and `Done:` line.
- Marker forms live in `ravintio-zero/standards/workflow-governance-standards.md` and `agent-dispatch-standards.md`.
