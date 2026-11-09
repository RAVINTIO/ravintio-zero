---
title: "Postmortem: 2026-11-08 - archived step cannot fix its own CI"
summary: "Step 6 of initiative 0000360 handed PR #136 to the queue before CI ran, then could not fix the CI failure because ship had already archived its run."
status: "open"
---
# Postmortem: 2026-11-08 - archived step cannot fix its own CI

**Trigger:** Blocked stop
**Feature:** 0000382-install-lifecycle (initiative 0000360-backlog-sweep, step 6)
**Date:** 2026-11-08

## Summary

PR #136 failed two CI jobs that the local suite passed. The step could not repair the PR because ship had archived `plan/current/` before CI ran, and `gate-write` rejects code edits without `plan/current/design.md`. The step blocked three times in one driver run. Steps 9, 12, 13, 16, and 18 waited behind it for about seven hours.

## Timeline

| Time (UTC) | Event | Evidence |
|------------|-------|----------|
| 03:20:58 | P3 records a full local pass: 317 feature suites and 19 regression suites, PowerShell under `pwsh` only. | commit `90fc91ee` |
| 03:21:53 | Ship archives the run to `plan/_archive/0000382-install-lifecycle-2026-11-08/` and empties `plan/current/`. | commit `9e77d25f` |
| 03:22:12 | Ship raises PR #136. | `gh pr view 136` `createdAt` |
| 03:22:28 | The step writes `ready` and ends with "Its CI has not run yet". It never ran `gh pr checks --watch`. | `plan/.initiative-logs/step-6.attempt-4.log`, last assistant text |
| 03:35:26 | CI run 42442445686 fails `bash-suites` and `windows-powershell (powershell)`. | `gh run view 42442445686` |
| after 03:35 | The merge queue stops: `merge-queue: CI failed on PR #136`. | `step-6.attempt-4.log` line 972 |
| 09:18:04 | The coordinator queues a CI-fix instruction for step 6. Its destination is `plan/current/coordinator-instruction-ci.md`. | `plan/.initiative-queue/fix-ci-step-6/item.md` |
| 09:18:15 | A step 6 attempt starts and writes an empty log. | `plan/.initiative-logs/step-6.attempt-5.log`, 0 lines |
| 09:57:17 | The step reports `I-D Advance: Blocked:` because `gate-write` rejects the fix with no `plan/current/design.md`. | `plan/.initiative-logs/step-6.log` |
| 09:57:31 | The driver resumes the session with "Read plan/current/build-log.md first". The step blocks again. | `step-6.log`, `initiative-run.mjs` `CONTINUE_PROMPT` |
| 09:57:42 | Second resume. The step blocks a third time and asks for a route. | `step-6.log` |
| 10:25 | The human picks "restore the design". The coordinator queues the route. | `plan/.initiative-queue/fix-ci-step-6/instruction.md` |

First missed chance to catch it: 03:22:28. Ship step 4.2 in the roadmap standards requires `gh pr checks {n} --watch` before the step writes `ready`. Nothing checked that the step ran it, so the queue found the failure instead.

## 5 whys

1. Why did step 6 block? It could not edit code to fix PR #136, because `gate-write` requires `plan/current/design.md` and ship had already archived it.
2. Why was the run archived while CI was still open? The ship sequence archives `plan/current/` before it raises the PR and waits for CI. The chart field `**Step CI fixes:** allowed` assumes the step can still edit after the CI wait, but that path no longer exists by then.
3. Why did nothing define how to reopen the run? The roadmap standards and `ravintio-ship` name no procedure for restoring an archived run to fix CI. The queued instruction pointed at `plan/current/`, which did not exist.
4. Why did the step block three times instead of once? The driver detects a block only from the build log in `plan/current/` or a newly archived one. The step could write neither, so the driver saw no block and resumed twice with a prompt that named a missing file.
5. Why did CI fail at all after a full local pass? The test workspaces relied on a global git identity. The local run used `pwsh` but not Windows PowerShell 5.1, which keeps a BOM on `CLAUDE.md`. The local suite has no mode that removes the global git identity, and no fixture with a BOM.

**Gap:** the ship sequence archives the run before the CI gate, and no standard defines how a step reopens an archived run. The driver's block detection depends on a file that the step can no longer write.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Step 6 restores `design.md` and `build-log.md` from its archive, fixes both CI jobs, watches CI to green, and archives again. | done | step 6 | `feat/0000382-install-lifecycle` | green CI on PR #136 | PR #136 |
| preventive | Ship waits for green CI on the PR before it archives `plan/current/`, or the standards define a reopen procedure that `gate-write` accepts. A step writes `ready` only after green CI. | filed | ravintio-ship, roadmap standards | `ravintio-zero/skills/ravintio-ship/SKILL.md`, `ravintio-zero/standards/roadmap-standards.md` | a test that a step with a failing check can push a fix | 0000412 |
| detective | The driver reads `Blocked:` and `Question:` lines from the session's final reply as well as the build log. The continue prompt never names a missing file. | filed | driver | `ravintio-zero/scripts/initiative-run.mjs` | a stub session test that blocks in its reply with no build log | 0000413 |
| detective | The local suite runs test workspaces with no global git identity, and a `doctor` fixture carries a BOM. | filed | tests | `ravintio-zero/tests/helpers/assert.sh` | the suite fails locally on the two defects from PR #136 | 0000414 |
