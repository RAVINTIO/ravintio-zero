---
title: "Discovery - 0000320-quiet-session-start"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000320-quiet-session-start

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source beside `plan/_archive/` (only signal, assumed without asking) |
| Git pre-flight | Initiative step. Branch `feat/0000320-quiet-session-start` cut from `initiative/0000312-guards-history-and-test-noise`. Working tree clean at start. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.45.0`
- Prior features (`plan/_archive/`): latest are 0000317 to 0000319.
- Constraining ADRs (unless superseded): none touch the hooks or the migrator.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. No data store.
- Repo instructions: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`.
- Pending migrations: 0004 and 0005 stay pending. Neither applies to this repo.
- Backlog: step 8 pulls in entries 0000307, 0000282, and 0000322.
- Relevant text: `ravintio-zero/hooks/enforcement/auto-trigger-orchestrator.mjs`, `check-orchestrator-presence.mjs`, `check-reply-prefix.mjs`, `ravintio-zero/scripts/resume-detect.mjs`, `ravintio-zero/skills/ravintio-migrator/SKILL.md`, `ravintio-zero/migrations/`, `plan/state/`.
- Host facts (Claude Code hooks docs, read 2026-11-01): every hook receives `session_id`. The Stop payload carries `last_assistant_message`.
- Chart decisions for this step: limit entry 0000282 to migration findings, and apply the new migration in this repo.
- Guard check: the step changes two advisory hooks that always exit 0 and a read-only script. It widens no guard.
- Setup stop after this step: `Setup:`, because the step changes two hooks, a script, and the migrator skill.
