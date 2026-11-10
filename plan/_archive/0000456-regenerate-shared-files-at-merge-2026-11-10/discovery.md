---
title: "Discovery - 0000456-regenerate-shared-files-at-merge"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000456-regenerate-shared-files-at-merge

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs, source in src/` |
| Git pre-flight | `feat/0000456-regenerate-shared-files-at-merge in the driver worktree, cut from the initiative branch` |
| Skills inbox | `empty` |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.80.1`
- Prior features (`plan/_archive/`): 0000454 queue failure recovery (merge-queue.mjs revert of stale set-version commits), 0000378 merge-time versioning
- Constraining ADRs: 0299 (queue failure recovery), 0295 (src layout, edit src then sync)
- Component map: one component, `ravintio-zero`. Source in `src/ravintio-zero/`, installed copy in `ravintio-zero/`.
- Backlog entry 0000430 (high, initiative): the queue merges the base into the PR branch and stops on any conflict. Every merge edits `docs/architecture-overview.md`, `docs/decisions-index.md`, `plan/backlog/index.md`, `plan/backlog/.next-id`, or `docs/adr/.next-id`.
- Repo instructions: git permissions, commit granularly, subagent decomposition, ship push, standing setup refresh approval.
- Pending migration 0009: left pending, it needs a human.
