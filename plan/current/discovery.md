---
title: "Discovery - 0000318-titled-coordinator-prs"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000318-titled-coordinator-prs

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source beside `plan/_archive/` (only signal, assumed without asking) |
| Git pre-flight | Initiative step. Branch `feat/0000318-titled-coordinator-prs` cut from `initiative/0000312-guards-history-and-test-noise`. Working tree clean at start. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.43.0`
- Prior features (`plan/_archive/`): latest are 0000313 to 0000317 (all 2026-10-31).
- Constraining ADRs (unless superseded): ADR-001 of 0000316 (hook launcher) and ADR-001 of 0000317 (forced-add guard). Neither touches `merge-guard` behaviour.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. No data store.
- Repo instructions: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`.
- Pending migrations: 0004 and 0005 stay pending. Neither applies to this repo (no `planifest-*` folder, no `roadmap.md` draft, no `roadmap/**` workflow pattern).
- Backlog: step 6 pulls in entry 0000274.
- Relevant text: `ravintio-zero/skills/ravintio-initiative/SKILL.md` (Backlog queue, Repo instructions during a run, I-E Delivery), `ravintio-zero/standards/roadmap-standards.md` (Merge carve-out, Ship stages, I-D Advance, I-E Delivery), `ravintio-zero/skills/ravintio-ship/SKILL.md` (PR number, merge line), `ravintio-zero/hooks/enforcement/merge-guard.mjs`.
- Chart decisions for this step: add coordinator PRs to the written merge carve-out under the bar in `initiative.md` `## Coordinator PRs`. `merge-guard` stays unchanged. Update `initiative.md` in the same step if the chart format changes.
- Guard check: the step widens the written carve-out only. The hook keeps its behaviour, and a test pins it.
- Setup stop after this step: `Restart:` and `Setup:`, because the step changes the initiative skill and other skills.
