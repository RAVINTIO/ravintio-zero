---
title: "Discovery - 0000536-pending-migrations-reach-the-human-early"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000536-pending-migrations-reach-the-human-early

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior features. Assumed without asking. |
| Git pre-flight | `feat/0000536-pending-migrations-reach-the-human-early`, cut by the driver from the initiative ref in a step worktree |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.112.0`. The step bump is minor.
- Prior features (`plan/_archive/`): the latest is 0000521-replies-name-actors-by-role (2026-11-11).
- Constraining ADRs: ADR-0310 (approved setup command through `Confirmation:` rows), ADR-0318 (`Question:` lines), ADR-0321 (reply actor names). None conflicts.
- Component map: one component, `ravintio-zero` (the pack). Pack source lives in `ravintio-zero/`.
- Backlog entry 0000537 is the only input. It names no schema change.
- Check 1 of resume detection currently tells every session to invoke `ravintio-migrator` for each pending migration. A step session has no human, so the session stops.
- `plan/state/migrations.md` holds a ledger. The pack holds migrations 0004 to 0009 and the ledger has no pending row now.
