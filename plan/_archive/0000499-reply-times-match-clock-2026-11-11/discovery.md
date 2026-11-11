---
title: "Discovery - 0000499-reply-times-match-clock"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000499-reply-times-match-clock

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000499-reply-times-match-clock`, cut from `initiative/0000360-backlog-sweep` at `2bc29f6f`. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.100.0`. The chart bump for step 51 is `minor`.
- Prior features (`plan/_archive/`): 0000489 added the Question check to `check-reply-prefix.mjs`. 0000468 added the clock check with a 5 minute margin.
- Constraining ADRs: 0305 (reply time clock check, warns and never blocks), 0318 (Question asks the human), 0200 ADR-002 (the Stop hook never blocks a turn).
- Component map: one component, `ravintio-zero`. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- Backlog entry 0000500 (evidence: `plan/.initiative-logs/step-27.log`, 2026-11-11 00:17 to 00:22): step 27 printed reply times 10 to 13 minutes ahead of the clock. It used the status `Running:`. Step 43 read `date +%H:%M` once and estimated every later time.
- The Stop hook runs at the end of a turn. A step session is one long turn, so the hook never sees the progress lines that drift.
- Wanted outcome, from the entry's replacement action list:
  1. A `PostToolUse` hook returns the local time as `hh:mm` in `additionalContext` after every tool call.
  2. The orchestrator skill, the initiative skill, and the roadmap standards require a fresh clock read for every timestamp.
  3. The reply-prefix hook flags a prefix time more than 2 minutes from the clock, and a status outside the allowed list.
  4. The watcher stamps each `activity:` line with its own clock. The entry says "driver", but the watcher prints these lines.
  5. A test checks that setup installs the hook and that its output holds the current time.
- The orchestrator `SKILL.md` is 8987 of 9000 bytes. The rule text goes into the standards and reference files.
- The entry widens no guard. The new hook adds context only, and the margin and status checks tighten a warning.
- Decisions rows for step 51: none. No row names step 51.
- Migration 0009 stays pending: it needs a y/n answer and a step session has no human.

## Coaching record

None. An initiative step self-confirms its design.
