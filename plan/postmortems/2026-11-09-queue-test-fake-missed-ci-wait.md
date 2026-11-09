---
title: "Postmortem: 2026-11-09 - queue test fake missed the new CI wait"
summary: "A blameless record of why a failure got through earlier phases, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-09 - queue test fake missed the new CI wait

> Path: `plan/postmortems/{date}-{slug}.md`. Written by `ravintio-postmortem`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Trigger:** P2 self-correction
**Feature:** 0000411-queue-waits
**Date:** 2026-11-09

## Summary

The first run of the new 0000411 suite never finished. Its fake `gh` answered `gh pr checks` with no output, so the queue sat in the CI wait that step 16 (0000392) had merged into `merge-queue.mjs` minutes earlier.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-09T16:50Z | Step 16 merges PR #134, which adds `waitForChecks` to `merge-queue.mjs` | commit `805b3cd4` |
| 2026-11-09T16:51Z | Plan reads `cmdRun` from a copy taken at 15:50, before step 16 merged | `plan/current/execution-plan.md` |
| 2026-11-09T16:55Z | The new suite's first run does not finish in 120 seconds | build log, P2 `Rework:` line |
| 2026-11-09T17:00Z | A trace shows the queue polling `gh pr checks --json`. The fake now answers with a passing check, and the suite passes | commit `5e3a46f0` |

First missed chance to catch it: P1 read the script before the base moved, and nothing compared it with the branch point.

## 5 whys

1. The suite did not finish, because the queue waited for CI checks that the fake never reported.
2. The fake reported no checks, because it was written against the script as read before step 16 merged.
3. The script was read early, because the plan took its source from an earlier read rather than the branch point.
4. Parallel steps change shared scripts often, so a read taken before the branch point goes stale within minutes.
5. The plan phase has no step that rereads changed source at the branch point.

**Gap:** the plan standard has no rule to reread the files a unit edits at the branch point when other work merges into the base during the run.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | The fake `gh` answers `gh pr checks --json` with a passing check | done | coordinator | `ravintio-zero/tests/test-0000411-req-001-queue-waits.sh` | the suite passes 9 of 9 | `5e3a46f0` |
| preventive | none, because the next initiative's driver fixes stop steps editing a shared script in parallel, and this hotfix runs once | none | coordinator | none | none | none |
| detective | none, because the existing time-limit helper `helpers/timeout.sh` already lets a suite fail fast, and the new suite sets a 20-second limit through `MQ_TIMEOUT_MS` | none | coordinator | none | none | none |
