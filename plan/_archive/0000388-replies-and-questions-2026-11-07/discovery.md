---
title: "Discovery - 0000388-replies-and-questions"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000388-replies-and-questions

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` has feature dirs and `docs/about.md` exists |
| Git pre-flight | `feat/0000388-replies-and-questions`, cut by the driver from `initiative/0000360-backlog-sweep` in a worktree. Clean tree. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.60.0`
- Prior features (`plan/_archive/`): 0000377 to 0000380 (driver stops, merge-time versioning, parallel steps, test helpers and rule anchors), all 2026-11-07
- Constraining ADRs: the 0000379 ADRs (concurrent driver) and the 0000380 rule-anchor convention. Tests read rules through `<!-- rule: {id} -->` anchors.
- Component map: one component, `ravintio-zero`. The pack has no `src/` component.

## Step inputs

- Backlog entries: 0000257, 0000258, 0000259, 0000306 (chart row 12). Bump: minor. Lane: orchestrator. After: 4 (merged).
- 0000258 solution is pre-approved by the chart: rename the warning "Reply prefix check", quote the first words of the reply, name the session, and skip the check in the coordinator session while a driver step runs, using the step session's environment marker.
- Repo instructions in `ravintio-overrides/instructions/`: git permissions and granular commits, subagent decomposition (orchestrator), ship push and PR, standing setup refresh.
- Past retrospectives: 0000380 (keep: fixture pack folders for helper tests. Change: step 7 extends the test impact scan, which does not touch this step), 0000378, 0000359.
- Queue: no `plan/.initiative-queue/` items.
