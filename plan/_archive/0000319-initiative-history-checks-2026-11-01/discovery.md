---
title: "Discovery - 0000319-initiative-history-checks"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000319-initiative-history-checks

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source beside `plan/_archive/` (only signal, assumed without asking) |
| Git pre-flight | Initiative step. Branch `feat/0000319-initiative-history-checks` cut from `initiative/0000312-guards-history-and-test-noise`. Working tree clean at start. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.44.0`
- Prior features (`plan/_archive/`): latest are 0000313 to 0000318.
- Constraining ADRs (unless superseded): ADR-001 of 0000318 (coordinator PRs in the carve-out). `merge-guard` stays unchanged. ADR-002 of 0000169 (CI tags the merge commit on `main`).
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. No data store.
- Repo instructions: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`.
- Pending migrations: 0004 and 0005 stay pending. Neither applies to this repo.
- Backlog: step 7 pulls in entries 0000275, 0000277, and 0000278.
- Relevant text: `.github/workflows/ravintio.yml` (tracked copy, setup writes it only when missing), `ravintio-zero/hooks/ravintio.yml` (pack copy), `ravintio-zero/scripts/release-tag.mjs`, `ravintio-zero/standards/roadmap-standards.md` (I-E Delivery), `ravintio-zero/skills/ravintio-initiative/SKILL.md` (I-E Delivery), `plan/current-initiative/initiative.md` (`## History check`).
- Chart decisions for this step: change both workflow copies. Parse the merge commit message to find an initiative PR. The history script has no exception list.
- Guard check: no hook changes. The step adds CI checks only, so it widens no guard.
- Setup stop after this step: `Setup:` only if the step changes the pack's hooks. The pack's `ravintio.yml` is a workflow template, not an installed hook.
