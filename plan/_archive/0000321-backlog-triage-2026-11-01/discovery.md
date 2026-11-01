---
title: "Discovery - 0000321-backlog-triage"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000321-backlog-triage

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source beside `plan/_archive/` (only signal, assumed without asking) |
| Git pre-flight | Initiative step. Branch `feat/0000321-backlog-triage` cut from `initiative/0000312-guards-history-and-test-noise`. Working tree clean at start. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.46.0`
- Prior features (`plan/_archive/`): latest are 0000318 to 0000320.
- Constraining ADRs (unless superseded): none touch the backlog.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. No data store.
- Repo instructions: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`.
- Pending migrations: 0004 and 0005 stay pending. Neither applies to this repo. Migration 0006 is `done` in `plan/state/migrations.md`.
- Backlog: step 9 pulls in entry 0000310. The backlog holds 59 folders and no `index.md`. No entry has `priority` or `theme`.
- Relevant text: `ravintio-zero/templates/backlog-entry.template.md`, `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-p0-start-actions.md` (Discovery Start Actions step 10), `ravintio-zero/skills/ravintio-file-backlog/SKILL.md`, `ravintio-zero/migrations/`, `.github/workflows/ravintio.yml`, `ravintio-zero/hooks/ravintio.yml`, `product.yml`.
- Tracked workflow: `.github/workflows/ravintio.yml` differs from the pack copy `ravintio-zero/hooks/ravintio.yml`. Setup does not overwrite the tracked file, so both change in this step.
- Chart decisions for this step: the review age is 5 days from **Date filed**, read from `product.yml`. The migration applies in this repo and is recorded in the ledger.
- Guard check: the step adds a CI check and a script. It widens no guard.
- Setup stop after this step: `Setup:`, because the step changes the backlog template and the orchestrator skill.
