---
title: "Discovery - 0000390-prose-checks"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000390-prose-checks

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` reads 0.70.0 |
| Git pre-flight | `feat/0000390-prose-checks`, cut by the driver from `initiative/0000360-backlog-sweep` (I-C Run) |
| Skills inbox | empty |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.70.0`
- Prior features (`plan/_archive/`): latest is 0000409-ci-shards (2026-11-09)
- Constraining ADRs (unless superseded): none read for this step
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`, which owns every pack file

## Step inputs

- Backlog entries 0000301 (prose linter with a baseline), 0000303 (P3 docs edit pass), 0000304 (advisory reply check)
- Writing standard from step 13: `ravintio-zero/standards/writing-standards.md`
- Existing prose check: `hooks/enforcement/em-dash-guard.mjs` (em dash only)
- Existing advisory Stop hook to model: `hooks/enforcement/check-reply-prefix.mjs`
- Hooks install as single files beside `read-stdin.mjs` (see `component.yml`), so shared code goes in `hooks/enforcement/`
- Chart rows: Decisions row for step 14 says the linter blocks new breaches only, against a per-file baseline
- Schema row: a per-file prose breach baseline (additive)
- Bump: minor
- Queue: `ci-gate-step-14` (CI before `ready`, restore route, blocks in the build log)
- Repo instructions: `ravintio-overrides/instructions/` holds four files, recorded in `design.md`
- Known risk: step 19 rewrites pack prose and step 20 moves the pack source. The baseline shrinks in step 19 and paths move in step 20.
