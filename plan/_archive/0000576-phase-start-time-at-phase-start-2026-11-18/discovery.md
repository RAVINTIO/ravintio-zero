---
title: "Discovery - 0000576-phase-start-time-at-phase-start"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000576-phase-start-time-at-phase-start

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000576-phase-start-time-at-phase-start`, cut by the driver from the initiative branch |
| Skills inbox | empty |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.142.0`
- Prior features (`plan/_archive/`): see the archive folder. Step 31 (0000575) merged last.
- Constraining ADRs: none found for this change.
- Component / data-ownership map: component `ravintio-zero` in `src/ravintio-zero/`, mirrored to `ravintio-zero/`.

## Step findings

- Entry 0000402 asks for a `build-log-check.mjs` check that flags a phase block whose `Start` is later than the first commit of that phase's artifacts.
- `build-log-check.mjs` has checks 1 to 9. Check 6 compares each logged time with the commit that adds its line.
- The Phase Invocation reference is `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-phase-invocation.md`. The entry asks it to name the new check.
- Pending migrations 0004 to 0009 do not apply to the pack source. The chart has no `Migration:` row, so the step logs them and carries on.
