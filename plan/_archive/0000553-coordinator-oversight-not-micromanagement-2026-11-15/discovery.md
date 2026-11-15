---
title: "Discovery - 0000553-coordinator-oversight-not-micromanagement"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000553-coordinator-oversight-not-micromanagement

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `source in src/ beside plan/_archive/` |
| Git pre-flight | `feat/0000553-coordinator-oversight-not-micromanagement, cut by the driver from the initiative ref. Initiative step, so no main check.` |
| Skills inbox | `empty` |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`, `docs/about.md`): `0.118.0`
- Prior features (`plan/_archive/`): steps 1 to 5 of initiative 0000544, the latest 0000549-baseline-record-checks (2026-11-14).
- Constraining ADRs: none read for this change.
- Component / data-ownership map: one component, `ravintio-zero`. Pack edits go in `src/ravintio-zero/` and mirror to `ravintio-zero/` and `.claude/`.
- Target: `src/ravintio-zero/skills/ravintio-initiative/SKILL.md`. Its Reports section tells the coordinator to relay every `I-C Run: activity:` line at once.
