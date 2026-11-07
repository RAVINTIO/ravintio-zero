---
title: "Discovery - 0000351-step-titles-and-history-shape"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000351-step-titles-and-history-shape

> Initiative 0000349 step 1. Raw findings only.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` holds version 0.48.1 |
| Git pre-flight | Branch `feat/0000351-step-titles-and-history-shape`, cut from `initiative/0000349-clean-initiative-history`. The tree was clean. |
| Skills inbox | empty (no `ravintio-zero/skills-inbox/`) |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md` and `product.yml`): `0.48.1`. Step `Bump` is `minor`, so the target is `0.49.0`.
- Prior features: latest archive is `0000327-squash-before-main` (2026-11-01).
- Constraining ADRs: none read for this step. P1 reads the ADRs of `0000319` (history check) and `0000327` (squash before main).
- Component map: one component, `ravintio-zero`, from `product.yml`. No data stores.
- Repo instructions: `custom-001` (git permissions), `custom-002` (subagent decomposition), `custom-004` (ship pushes and raises the PR), `custom-006` (setup refresh approval).
- Migrations: `0004` and `0005` have `not applicable` rows in `plan/state/migrations.md`. Nothing ran.

## Step input

- Chart row: step 1, `Step titles and history shape`, bump `minor`, P1 not skipped.
- Backlog entries: `0000350`, `0000339`, `0000345` (rule 4 only), `0000268`.
- Entry `0000345` stays in the backlog. Steps 2 and 3 own its other rules.
- Chart decisions that apply: title form `{feature-id}: {Feature title} (#{n})`, chore form `{initiative-id}: Initiative admin (#{n})`. The `Title` column drives the check. The check reads only the commits between the PR base and head. The step adds the `Title` column to the initiative template and the entry 0000268 rule.
- Criterion: `check-initiative-history.mjs` passes a fixture with N titled steps and one chore commit. It fails a mistitled step and an extra commit between steps. Deterministic, checked locally.

## Past retrospectives

- `0000327-squash-before-main-2026-11-01.md`, `0000321-backlog-triage-2026-11-01.md`, `0000320-quiet-session-start-2026-11-01.md`. The open changes they filed are the entries of this initiative.
