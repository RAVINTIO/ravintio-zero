---
title: "Discovery - 0000555-initiative-pause-reaches-every-step"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000555-initiative-pause-reaches-every-step

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source in `src/` beside an archive in `plan/_archive/` |
| Git pre-flight | Branch `feat/0000555-initiative-pause-reaches-every-step`, cut by the driver from the initiative branch |
| Skills inbox | empty |
| Track | light |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.128.0`
- Prior features (`plan/_archive/`): earlier initiative steps, see the archive folder names.
- Component and data-ownership map: component `ravintio-zero` owns the pack. `src/ravintio-zero/` is the source and `ravintio-zero/` is the mirror.
- Repo instructions (`ravintio-overrides/instructions/`): git permissions, subagent decomposition, ship push and PR, and the standing setup approval.
- Backlog entry: 0000538-initiative-pause-reaches-every-step. On 2026-11-12 the coordinator wrote each pause file by hand when the human paused initiative 0000360. The orchestrator pause command covers one feature only.
- Files that hold the behaviour: `scripts/initiative-run.mjs` (the scheduler loop, the control folders, the signal handlers), `scripts/resume-detect.mjs`, `templates/pause.template.md`, `skills/ravintio-initiative/SKILL.md` (117 lines, limit 119), `standards/roadmap-standards.md`, and `skills/ravintio-orchestrator/references/orchestrator-resume-detection.md`.
