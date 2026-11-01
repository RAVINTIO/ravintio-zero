---
title: "Discovery - 0000315-isolated-test-state"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000315-isolated-test-state

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source beside `plan/_archive/` (only signal, assumed without asking) |
| Git pre-flight | Initiative step. Branch `feat/0000315-isolated-test-state` cut from `initiative/0000312-guards-history-and-test-noise`. Working tree clean at start. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.41.1`
- Prior features (`plan/_archive/`): latest are 0000253-refresh-setup (2026-10-29), 0000313-driver-setup-stop and 0000314-step-logs-stay-in-place (2026-10-31).
- Constraining ADRs (unless superseded): not read at discovery. P1 reads those that touch the test runner.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. No data store.
- Repo instructions: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`.
- Pending migrations: 0004 and 0005 stay pending. Neither applies to this repo.
- Backlog: step 3 pulls in entries 0000309 and 0000267.
- Relevant code: `ravintio-zero/tests/run-tests.sh` already runs `unset RAVINTIO_INITIATIVE_STEP` (0000251). `run-tests.ps1` does the same. `test-0000164-req-007-gate-write-doc-correction.sh` lists `CLAUDE.md` first in `FILES` and fails on a generated copy. Suites that read or write `RAVINTIO_*` variables or `plan/backlog/.next-id`: see `grep` of `RAVINTIO_TEST_QUIET`, `next-id`, and `RAVINTIO_INITIATIVE_STEP` in `ravintio-zero/tests/`.
- Runner config variables to keep: `RAVINTIO_PWSH`, `RAVINTIO_REQUIRE_PWSH`, `RAVINTIO_PREFLIGHT_ONLY`, `RAVINTIO_TEST_QUIET`.
- Chart decision: when a suite fails once the runner clears `RAVINTIO_*`, the suite sets the variable it needs.
- Past retrospectives: 0000208, 0000218, 0000251 (the source of entry 0000309).
