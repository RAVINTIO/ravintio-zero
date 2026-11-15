---
title: "Discovery - 0000548-ack-write-mid-suite-fails-run"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000548-ack-write-mid-suite-fails-run

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `docs/about.md` and `plan/_archive/` hold prior features |
| Git pre-flight | Branch `feat/0000548-ack-write-mid-suite-fails-run`, cut by the initiative driver from `initiative/0000544-priority-backlog`. Step session, so no human confirmation. |
| Skills inbox | empty |
| Track | `light` (the chart accepts the track for a fix) |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.114.0`. Step bump: minor.
- Prior features (`plan/_archive/`): latest are 0000534, 0000536, 0000521.
- Constraining ADRs: none read for this fix. The strict-mode hook is ADR-governed by 0000320 and 0000399.
- Component map: one component, `src/ravintio-zero/`, mirrored to `ravintio-zero/`. `diff -rq` shows no difference at the start.

## Findings for this step

- Backlog entry 0000476-ack-write-mid-suite-fails-run: the strict hook `check-orchestrator-presence.mjs` asks a step session to write `plan/.orchestrator-ack` when the session id differs from the recorded one. A background suite run gets that prompt mid-run. The write changes a tracked file, and `run-tests.sh` exits 1 with "Tree changed during the run".
- Chart decision (Guard cut-back): never exempt `plan/.orchestrator-ack` from the tree check. Fix the cause in the hook or the session.
- Queue items for step 4: none.
- Pending migrations: none.
- Repo instructions: four files in `ravintio-overrides/instructions/`.
