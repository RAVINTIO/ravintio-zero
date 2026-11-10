---
title: "Discovery - 0000397-pack-source-in-src"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000397-pack-source-in-src

> Created at the start of discovery (P0). Raw findings only.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` holds version 0.75.0 |
| Git pre-flight | `feat/0000397-pack-source-in-src`, cut by the driver from `initiative/0000360-backlog-sweep` at 2adff7e3. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.75.0`. Step 20 plans a minor bump. The merge queue sets the released version.
- Prior features (`plan/_archive/`): 0000395 pack prose to the standard (2026-11-09), 0000411, 0000409, 0000405.
- Constraining ADRs: `docs/adr/` holds the repo-wide ADRs. None forbids a source folder under `src/`.
- Component map: one component, `ravintio-zero`, declared in `ravintio-zero/component.yml`. `src/` holds only `README.md`.

## Findings for this step

- Backlog entry 0000396 is the only input. Its row in `initiative.md` is step 20, bump `minor`, depends on step 19.
- The tree holds 681 tracked files under `ravintio-zero/` and 2954 in total.
- Consumers of `ravintio-zero/` outside it: `.claude/` hooks and settings, `.github/workflows/`, `product.yml`, `refresh-ravintio-zero-dir.ps1`, `.gitattributes`, `README.md`, `CONTRIBUTING.md`, `SECURITY.md`, and `plan/feature-structure.md`.
- Stale state: `plan/current/` and `plan/.feature-id` held step 19's committed leftovers. Commit 98da5ede cleared them. The archive copy in `plan/_archive/0000395-pack-prose-to-the-standard-2026-11-09/` is intact.
- Pending migrations 0004, 0005, and 0008 do not apply, because their `Applies when:` condition is false. Migration 0009 applies to the pack source, but `docs/adr/` already holds 294 ADRs and the migration says it is safe to skip. This step does not run the migrator, because it needs an interactive session. It stays pending.
- Coordinator queue item `ci-gate-step-20` names this step. The step copied its rules to `plan/current/coordinator-instruction-ci-gate.md`. Item `narrow-brand-guard-self-entry` names step 18 and does not apply.
- Repo instructions (`ravintio-overrides/instructions/`): git permissions, subagent decomposition, push and raise the PR without merging, and the standing setup refresh approval.
