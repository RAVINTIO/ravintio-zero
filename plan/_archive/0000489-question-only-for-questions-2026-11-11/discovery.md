---
title: "Discovery - 0000489-question-only-for-questions"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000489-question-only-for-questions

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000489-question-only-for-questions`, cut from `initiative/0000360-backlog-sweep` at `83ffac21`. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.98.0`. The chart bump for step 46 is `minor`.
- Prior features (`plan/_archive/`): 0000487 is the latest archived run for this initiative. It added `decision-rows.mjs`.
- Constraining ADRs (unless superseded): ADRs live in `docs/adr/`.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- Backlog entry 0000490 (evidence: `plan/.initiative-logs/step-31.log`, 2026-11-10 15:06): step 31 ended its turn with `I-C Run: Question: step 31 is partway through` while it only waited for its suites. It also called ScheduleWakeup, which a `claude -p` step session cannot use.
- `SKILL.md` line 53 calls `Question:` a routine question. Line 63 lists a `Question:` line as a valid end of turn. Neither says a step that waits on its own work keeps working.
- The driver stops on any open `Question:` line, so a false one reads as a stop that needs the human.
- `check-reply-prefix.mjs` is the Stop hook that checks the reply prefix. It checks the prefix only and ignores the status.
- Wanted outcome: the orchestrator and step instructions say that `Question:` asks the human something. A check flags a final reply whose `Question:` line holds no question mark.
- The entry widens no guard. The check adds a warning and blocks nothing.
- Decisions rows for step 46: none. No row names step 46.

## Coaching record

None. An initiative step self-confirms its design.
