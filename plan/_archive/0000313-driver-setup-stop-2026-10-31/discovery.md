---
title: "Discovery - 0000313-driver-setup-stop"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000313-driver-setup-stop

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source beside `plan/_archive/` (only signal, assumed without asking) |
| Git pre-flight | Initiative step. Branch `feat/0000313-driver-setup-stop` cut from `initiative/0000312-guards-history-and-test-noise`. Working tree clean at start. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.40.1`
- Prior features (`plan/_archive/`): latest are 0000251-driver-step-fixes (2026-10-28), 0000252-chart-rules (2026-10-28), 0000253-refresh-setup (2026-10-29).
- Constraining ADRs (unless superseded): not read at discovery. P1 reads those that touch the driver.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. No data store.
- Repo instructions: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`.
- Pending migrations: 0004 and 0005 stay pending. Neither applies to this repo.
- Backlog: step 1 pulls in entry 0000311 only.
- Relevant code: `WATCHED` list at `ravintio-zero/scripts/initiative-run.mjs:25-30`, `changedWatched` at line 372, and the `Restart:` stop at lines 504-508. The `Restart:` handling in the initiative skill is at `ravintio-zero/skills/ravintio-initiative/SKILL.md:78`.
