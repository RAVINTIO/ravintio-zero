---
title: "Discovery - 0000468-reply-time-matches-the-clock"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000468-reply-time-matches-the-clock

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000468-reply-time-matches-the-clock`, cut from `initiative/0000360-backlog-sweep` at `79e47ef9`. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.83.0`. The chart bump for step 38 is `minor`. The merge queue sets the released version.
- Prior features (`plan/_archive/`): `0000388-replies-and-questions` added the leading `hh:mm` and the shape-only check in `check-reply-prefix.mjs`. `0000440` added the reply block.
- Constraining ADRs (unless superseded): ADR-002 of 0000200. The Stop hook warns and logs and never blocks a turn.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- Steps 14, 15, and 19 typed reply times up to an hour off. `check-reply-prefix.mjs` accepts any `hh:mm` through `TIME_RE`, which checks the shape only.
- The `UserPromptSubmit` hook injects the time as context. The reply rule does not tell the step to read the clock before each reply.
- The rule text sits in `standards/roadmap-standards.md` (`reply-time-form`), the orchestrator and initiative skills, and the boot templates.
- Suites `test-0000388-req-001-time-before-prefix.sh` and `test-0000388-req-002-clear-prefix-warning.sh` use fixed times such as `06:43`. They need a fixed clock once the hook compares against the real one.
- Backlog pickup: 0000434, named by the step 38 row.
- Migration 0009 stays pending. Its migrator asks y/n and a step session has no human.

## Coaching record

None. An initiative step self-confirms its design.
