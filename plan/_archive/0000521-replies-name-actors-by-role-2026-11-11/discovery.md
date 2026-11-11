---
title: "Discovery - 0000521-replies-name-actors-by-role"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000521-replies-name-actors-by-role

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000521-replies-name-actors-by-role`, cut from `initiative/0000360-backlog-sweep` at `7c2a8186`. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.102.0`. The chart bump for step 59 is `minor`.
- Prior features (`plan/_archive/`): 0000519 is the latest archived run for this initiative.
- Constraining ADRs (unless superseded): ADRs live in `docs/adr/`. ADR-0288 holds the shared prose rules module.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- Backlog entry 0000522: replies use "I" for the agent and "you" for the human. A coordinator report names a step session, the coordinator, the driver, and the human, so the pronouns leave the reader to guess the actor.
- The fix names each actor by role in the reply conventions: `ravintio-zero/templates/standard-boot.md` (the source of `CLAUDE.md`), `ravintio-zero/templates/codex-boot.md`, the orchestrator skill, and `ravintio-zero/standards/roadmap-standards.md`.
- The advisory reply hook `check-reply-writing.mjs` gains a rule that flags "I" and "you" in a reply that opens with a run prefix.
- The initiative skill heading `Decisions for you` becomes `Decisions for the human`. Test `test-0000450-req-004-report-format.sh` and the roadmap standards line pin the old text.
- The orchestrator `SKILL.md` holds 8987 of 9000 bytes. The edit must move text out to stay under the cap.
- Git ignores `CLAUDE.md` and `.claude/`. Setup regenerates them, so the step edits only the sources.
- Migration 0009 stays pending. It needs a y/n answer and a step session has no human.
- Decisions rows for step 59: none. No row names step 59.
- Queue: `plan/.initiative-queue/` does not exist. No item names step 59.

## Coaching record

None. An initiative step self-confirms its design.
