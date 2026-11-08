---
title: "Discovery - 0000382-install-lifecycle"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000382-install-lifecycle

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` reads 0.61.0 |
| Git pre-flight | Initiative step. Branch `feat/0000382-install-lifecycle` in worktree `plan/.initiative-worktrees/step-6`, cut by the driver |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.61.0`. The merge queue sets the released version.
- Prior features (`plan/_archive/`): 0000377 to 0000381, steps 1 to 5 of initiative 0000360.
- Constraining ADRs: not re-read at discovery. P1 reads them.
- Component map: one component, `ravintio-zero`, with no data store.
- Repo instructions (`ravintio-overrides/instructions/`): read at P0, recorded in `design.md`.
- Step 6 inputs: backlog entries 0000283, 0000299, 0000292, 0000291, 0000298, and 0000286. Step 6 has no queue items.
- Step 6 chart row: bump `minor`, lane `setup`, after step 5. Schema row: the setup manifest records every write, including pack-owned commands (additive).
- Decision rows that apply: uninstall needs an explicit `--uninstall` flag, prints each guard it removes, and refuses while `plan/.orchestrator-active` or `plan/.initiative-runner.lock` exists. Strict mode stays on across re-runs, and only `--no-strict-orchestrator` turns it off. The update command commits pack files first. The setup rerun `Confirmation:` row.
- Pending migrations 0004, 0005, and 0008: their `Applies when:` conditions are false in the pack source, so they stay pending.
