---
title: "Discovery - 0000327-squash-before-main"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000327-squash-before-main

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source beside `plan/_archive/` (only signal, assumed without asking) |
| Git pre-flight | Initiative step. Branch `feat/0000327-squash-before-main` cut from `initiative/0000312-guards-history-and-test-noise`. Working tree clean at start. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.47.0`
- Prior features (`plan/_archive/`): latest are 0000319 to 0000321.
- Constraining ADRs (unless superseded): none touch PRs into `main`.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. No data store.
- Repo instructions: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`.
- Pending migrations: 0004 and 0005 stay pending. Neither applies to this repo.
- Backlog: step 10 pulls in entry 0000326.
- Relevant text: `ravintio-zero/skills/ravintio-ship/SKILL.md` (Hard Limit 5, Step 9), `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-p0-start-actions.md` (step 2), `ravintio-zero/standards/roadmap-standards.md` (Merge carve-out), `ravintio-zero/docs/main-ruleset.md`, `.github/workflows/ravintio.yml`, `ravintio-zero/hooks/ravintio.yml`, `ravintio-zero/scripts/check-main-merge.mjs` (model for the new script).
- Tracked workflow: `.github/workflows/ravintio.yml` differs from the pack copy `ravintio-zero/hooks/ravintio.yml`. Setup does not overwrite the tracked file, so both change in this step.
- Human-owned text: `CLAUDE.md` and `ravintio-overrides/instructions/custom-001-local-git-only.md` both say "Work on a feat/ branch". No setup source writes that sentence, so the pack holds no generator to change. Those two files stay as they are and the build report flags them.
- Chart decisions for this step: `--force-with-lease` on `chore/*` only. A `hotfix/*` branch gets a replacement PR. Pack text for a run outside an initiative changes from `feat/` to `hotfix/`.
- Guard check: the step adds a CI check and widens no hook. The force-push permission is the widening the human approved on 2026-10-31. No hook blocks a force-push today.
- Setup stop after this step: `Setup:`, because the step changes the ship and orchestrator skills and CI.
