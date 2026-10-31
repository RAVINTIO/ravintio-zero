---
title: "Discovery - 0000317-block-forced-adds"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000317-block-forced-adds

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source beside `plan/_archive/` (only signal, assumed without asking) |
| Git pre-flight | Initiative step. Branch `feat/0000317-block-forced-adds` cut from `initiative/0000312-guards-history-and-test-noise`. Working tree clean at start. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.42.0`
- Prior features (`plan/_archive/`): latest are 0000313 to 0000316 (all 2026-10-31).
- Constraining ADRs (unless superseded): ADR-001 of 0000316 (hook launcher). Every Claude Code hook command runs through `guard-run.mjs` with `guard` or `advisory` mode. A new guard must use `guard` mode.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. No data store.
- Repo instructions: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`.
- Pending migrations: 0004 and 0005 stay pending. Neither applies to this repo.
- Backlog: step 5 pulls in entry 0000276.
- Ignored driver paths today: `plan/.initiative-logs/`, `plan/.initiative-queue/`, and `plan/.initiative-runner.lock` sit only in `.git/info/exclude`. The tracked `.gitignore` lists `plan/.initiative-ack` and not the other three. `git ls-files -ci --exclude-standard` lists nothing now.
- Relevant code: `ravintio-zero/hooks/enforcement/merge-guard.mjs` (Bash guard, raw-text tripwire), `guard-run.mjs`, `setup.sh` `install_enforcement_hooks`, `setup.ps1` equivalents, `ravintio-zero/hooks/ravintio.yml`, `.github/workflows/ravintio.yml`.
- Chart decisions for this step: also block combined short flags such as `-fA` and the `git -C {dir} add -f` form. A tracked file that matches an ignore rule on purpose gets a negation rule in `.gitignore`, and the CI check stays.
- Guard check: the new hook adds a guard. It widens no existing guard.
- Setup stop after this step: `Setup:`, because the step adds a hook.
