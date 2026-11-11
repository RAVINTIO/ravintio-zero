---
title: "Discovery - 0000519-ship-removal-needs-human-approval"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000519-ship-removal-needs-human-approval

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000519-ship-removal-needs-human-approval`, cut from `initiative/0000360-backlog-sweep` at `2bc29f6f`. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.100.0`. The chart bump for step 58 is `minor`.
- Prior features (`plan/_archive/`): 0000489 is the latest archived run for this initiative.
- Constraining ADRs (unless superseded): ADRs live in `docs/adr/`.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- Backlog entry 0000518: ship Step 4 tells the agent to delete the contents of `plan/current/`. The Claude Code safety check refused the removal. Step 57 stopped with a `Blocked:` line from 04:55 to 06:53 until the coordinator ran `git rm -rq plan/current`.
- The fix: ship Step 4 runs `git rm -r -q plan/current` from the repo root, with a literal path, no `cd`, and no glob. A test checks that the ship skill names this command and names no `rm -r` of `plan/current/`.
- P2 in `ravintio-implement/SKILL.md` tells the agent to write docs while the full suite runs in the background. The runner fails on a changed tree. The text must say to write docs before the suite starts or after it ends.
- Both changes edit pack skills. The source is `src/ravintio-zero/skills/`, synced to `ravintio-zero/skills/` and the installed `.claude/skills/`.
- Migration 0009 stays pending. It needs a human answer and a step session has no human.
- Decisions rows for step 58: none. No row names step 58.
- Queue: `plan/.initiative-queue/` does not exist. No item names step 58.

## Coaching record

None. An initiative step self-confirms its design.
