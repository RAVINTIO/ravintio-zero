---
title: "Discovery - 0000379-parallel-steps-on-worktrees"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000379-parallel-steps-on-worktrees

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior features and `docs/about.md` holds version 0.58.0 |
| Git pre-flight | `feat/0000379-parallel-steps-on-worktrees`, cut from `initiative/0000360-backlog-sweep` (I-C Run) |
| Skills inbox | `ravintio-zero/skills-inbox/` holds only `capability-skills/`, no `SKILL.md` to process |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.58.0`. Step 3 applies a minor bump to `0.59.0`, set by the merge queue at merge (step 2 decision).
- Prior features (`plan/_archive/`): latest is `0000378-merge-time-versioning` (2026-11-07).
- Constraining ADRs: ADR-001 and ADR-002 of 0000378 (merge queue merges, merge order from the `Version` column).
- Component map: one component, `ravintio-zero`. `product.yml` policy is `max-component-version`.
- Repo instructions (`ravintio-overrides/instructions/`): custom-001 (local git, no worktrees), custom-002 (subagent decomposition), custom-004 (ship push and PR), custom-006 (setup refresh approval).
- Backlog entries for this step: 0000375.
- Migrations: 0004 and 0005 stay pending because their `Applies when` conditions are false in the pack source.
- Initiative decisions for this step: `**Concurrency:** 3`. The repo `CLAUDE.md` worktree rule is scoped to human sessions in `ravintio-zero/templates/standard-boot.md`, and setup regenerates this repo's `CLAUDE.md`.
- Step 2 left the driver wiring to this step: the driver calls `merge-queue.mjs`, and P4 stops bumping the version.
