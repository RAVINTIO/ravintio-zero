---
title: "Discovery - 0000316-hooks-fail-closed"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000316-hooks-fail-closed

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source beside `plan/_archive/` (only signal, assumed without asking) |
| Git pre-flight | Initiative step. Branch `feat/0000316-hooks-fail-closed` cut from `initiative/0000312-guards-history-and-test-noise`. Working tree clean at start. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.41.2`
- Prior features (`plan/_archive/`): latest are 0000313, 0000314, and 0000315 (all 2026-10-31).
- Constraining ADRs (unless superseded): not read at discovery. P1 reads those that touch hook wiring and settings merges.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. No data store.
- Repo instructions: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`.
- Pending migrations: 0004 and 0005 stay pending. Neither applies to this repo.
- Backlog: step 4 pulls in entries 0000287 and 0000288.
- Docs check (2026-10-31, code.claude.com): `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` exists and returns to the original working directory after each Bash or PowerShell command in the main session. `CLAUDE_PROJECT_DIR` is the project root where the session started. Command hooks receive it as an environment variable and as a `${CLAUDE_PROJECT_DIR}` placeholder. Exit 2 blocks a `PreToolUse` call. Exit 1 is a non-blocking error. Both chart-time confirmations hold, so the decision row "stop for the human" does not trigger.
- Relevant code: `ravintio-zero/setup.sh` `install_enforcement_hooks` (wires relative `node ".claude/hooks/enforcement/{hook}.mjs"` commands), `install_codex_hooks` (wires `$(git rev-parse --show-toplevel)` for merge-guard), `setup.ps1` equivalents, `ravintio-zero/hooks/enforcement/*.mjs`.
- Guards with exit 2 paths: `gate-write`, `ratchet-check`, `em-dash-guard`, `merge-guard`. Advisory hooks that always exit 0: `auto-trigger-orchestrator`, `check-orchestrator-presence`, `check-design`, `check-reply-prefix`.
- Existing tests to keep green: `test-0000035-req-001-hook-parity`, `test-0000038-*-hook-filter`, `test-0000043-req-006-merge-guard-hook`, `test-0000200-req-004-setup-wires-the-stop-hook`, `test-0000207-req-001-003-codex-setup`, `test-0000243-req-003-004-hook-injection`.
- Chart decisions: Codex hook commands carry the absolute project path. `setup.ps1` changes in the same step. A hook that fails to resolve after the setup rerun stops the initiative.
- Setup stop after this step: `Setup:`, then a check that every hook runs.
