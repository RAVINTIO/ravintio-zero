---
title: "Discovery - 0000381-setup-safety"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000381-setup-safety

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` reads 0.60.0 |
| Git pre-flight | Initiative step. Branch `feat/0000381-setup-safety` in worktree `plan/.initiative-worktrees/step-5`, cut by the driver |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.60.0`. The merge queue sets the released version.
- Prior features (`plan/_archive/`): 0000377 to 0000380, steps 1 to 4 of initiative 0000360.
- Constraining ADRs: not re-read at discovery. P1 reads them.
- Component map: one component, `ravintio-zero`, with no data store.
- Repo instructions (`ravintio-overrides/instructions/`): read at P0, recorded in `design.md`.
- Step 5 inputs: backlog entries 0000262, 0000289, 0000293, and 0000290. Step 5 has no queue items.
- Step 5 chart row: bump `minor`, lane `setup`, after step 4. Schema row: `.ravintio-manifest` paths relative to the repo root (additive).
- Decision rows that apply: the `rm -rf` path rule (resolve each path under the repo root, refuse any outside it, in `setup.sh` and `setup.ps1`), and the setup rerun `Confirmation:` row.
