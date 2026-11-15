---
title: "Discovery - 0000554-coordinator-starts-defined-stages"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000554-coordinator-starts-defined-stages

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source in `src/` beside an archive in `plan/_archive/` |
| Git pre-flight | Branch `feat/0000554-coordinator-starts-defined-stages`, cut by the driver from the initiative branch |
| Skills inbox | empty |
| Track | light |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.125.0`
- Prior features (`plan/_archive/`): earlier initiative steps, see the archive folder names.
- Component and data-ownership map: component `ravintio-zero` owns the pack. `src/ravintio-zero/` is the source and `ravintio-zero/` is the mirror.
- Repo instructions (`ravintio-overrides/instructions/`): git permissions, subagent decomposition, ship push and PR, and the standing setup approval.
- Backlog entry: 0000541-coordinator-starts-defined-stages. The coordinator asked "Go?" before I-E Delivery, a stage the pipeline already defines as next. Rule `coord-question-form` names no case where the coordinator acts without asking. Rule `driver-stop-summary` names delivery as the human's action.
- Files that hold the text: `standards/roadmap-standards.md`, `skills/ravintio-initiative/SKILL.md` (117 lines, limit 119), `scripts/initiative-run.mjs` (`humanAction`), and the tests `test-0000399-req-003-004-question-rule.sh` and `test-0000511-req-001-003-stop-summary.sh`.
