---
title: "Discovery - 0000384-plan-checks"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000384-plan-checks

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature directories and `docs/about.md` exists |
| Git pre-flight | `feat/0000384-plan-checks` in a step worktree, cut by the driver from the initiative branch. Step 7 (#132) is merged. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.62.0`. Step 8 charts a minor bump.
- Prior features (`plan/_archive/`): 0000377 to 0000383 from this initiative, the latest being 0000383-test-impact-scan (2026-11-07).
- Constraining ADRs: step 3 (0000379) fixes the worktree driver. Step 4 (0000380) adds `<!-- rule: {id} -->` anchors that tests read.
- Component map: one pack component, `ravintio-zero`. No `src/` component. Step 8 edits the plan skill, templates, a script, and the ADR layout.
- Backlog entries: 0000255, 0000263, 0000333, 0000347, 0000280, 0000364. All six are from the chart row.
- Stale backlog review: skipped. An initiative step takes entries from its row.
- Repo instructions: git permissions and commit cadence in `ravintio-overrides/instructions/`, and the subagent decomposition standing instruction.

## Past retrospectives

- 0000383-test-impact-scan, 0000381-setup-safety, 0000380-test-helpers-and-rule-anchors. Their open changes are not re-read here. Each step's own rows in `initiative.md` cover the recurring stops.
