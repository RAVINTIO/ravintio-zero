---
title: "Discovery - 0000314-step-logs-stay-in-place"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000314-step-logs-stay-in-place

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source beside `plan/_archive/` (only signal, assumed without asking) |
| Git pre-flight | Initiative step. Branch `feat/0000314-step-logs-stay-in-place` cut from `initiative/0000312-guards-history-and-test-noise`. Working tree clean at start. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.41.0`
- Prior features (`plan/_archive/`): latest are 0000252-chart-rules (2026-10-28), 0000253-refresh-setup (2026-10-29), 0000313-driver-setup-stop (2026-10-31).
- Constraining ADRs (unless superseded): not read at discovery. P1 reads those that touch the guard or the step logs.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. No data store.
- Repo instructions: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`.
- Pending migrations: 0004 and 0005 stay pending. Neither applies to this repo.
- Backlog: step 2 pulls in entries 0000264 and 0000265.
- Relevant code: the phase guard in `ravintio-zero/tests/test-0000042-req-006-phase-guard-and-stale-cites.sh` (`SCOPE` includes `plan`, `EXCLUDE` omits `plan/.initiative-logs`). Step logs are also named in `test-0000042-req-007`, `-008`, `-009`, and `-011`, and in `test-0000043-req-001`, `-002`, `-005`, `-008`, and `-009`. The orchestrator skill and initiative skill hold no rule about driver files.
- Chart decision: the guard skips `plan/.initiative-logs/` only. It never switches to tracked-only scanning.
- Past retrospectives: 0000252, 0000253, and 0000313. Open changes outside this step: entries 0000266, 0000268, 0000269, 0000270, 0000271.
