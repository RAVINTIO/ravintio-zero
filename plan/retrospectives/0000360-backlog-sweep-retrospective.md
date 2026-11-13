---
title: "Retrospective: 2026-11-10 - Backlog sweep stops and mistakes"
summary: "A blameless review of all 27 stops and mistakes in initiative 0000360, with a verdict for each and one backlog entry for each unaddressed finding."
status: "open"
---
# Retrospective: 2026-11-10 - Backlog sweep stops and mistakes

> Path: `plan/retrospectives/0000360-backlog-sweep-retrospective.md`. Written by `ravintio-retrospective` in step 22.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Mode:** initiative
**Subject:** 0000360-backlog-sweep
**Date:** 2026-11-10

## Summary

Initiative 0000360 ran 21 steps and added step 22 for this record. The 27 rows of `plan/_archive/0000360-backlog-sweep-initiative-2026-11-13/coordinator-evidence.md` group into 19 findings.

- Two findings (D and I) have a fix that covers the cause.
- Four findings (A, C, K, and O) have a fix for the symptom only.
- Thirteen findings have no covering fix.
- Three findings (A, B, and C) already had an open entry.
- This step filed 15 new entries, 0000423 to 0000437.

The pack placed too many routine repairs on the human and the coordinator. The driver, the queue, and the step handover held most of the gaps.

## Verdicts by row

| Row | Finding | Verdict |
|-----|---------|---------|
| 1 | A | Partly addressed by PR #139. Root cause unaddressed. Entry 0000412 |
| 2 | A | Partly addressed by PR #139 and PR #147 (0000411). Entry 0000412 |
| 3 | B | Unaddressed. Entry 0000413 |
| 4 | C | Partly addressed by PR #136. Entry 0000414 |
| 5 | D | Addressed by 0000405 (PR #140) |
| 6 | E | Unaddressed. Entry 0000430 |
| 7 | F | Unaddressed. Entry 0000431 |
| 8 | G | Partly addressed by PR #139. Entry 0000425 |
| 9 | H | Unaddressed. Entry 0000424 |
| 10 | H | Unaddressed. Entry 0000424 |
| 11 | I | Addressed by 0000392 (PR #134) and 0000411 (PR #147). Test gap in entry 0000400 |
| 12 | E | Unaddressed. Entry 0000430 |
| 13 | J | Unaddressed. Entry 0000429 |
| 14 | J | Unaddressed. Entry 0000429 |
| 15 | K | Partly addressed by 0000409 (PR #144). Entry 0000436 |
| 16 | L | Unaddressed. Entry 0000426 |
| 17 | M | Unaddressed. Entry 0000428 |
| 18 | N | Unaddressed. Entry 0000427 |
| 19 | G | Partly addressed by PR #147 (landed the files). Entry 0000425 |
| 20 | O | Addressed by 0000420 (PR #151) for the stale entry. Class unaddressed. Entry 0000433 |
| 21 | P | Unaddressed. Entry 0000435 |
| 22 | Q | Unaddressed. Entry 0000437 |
| 23 | M | Unaddressed. Entry 0000428 |
| 24 | R | Unaddressed. Entry 0000434 |
| 25 | G | Unaddressed. The instruction still sits in the queue. Entries 0000425 and 0000432 |
| 26 | M | Unaddressed. Entry 0000428 |
| 27 | S | Unaddressed. Entry 0000423 |

## Findings

Each finding lists its rows, a 5 whys chain that ends at a gap, its verdict, and its entry. Evidence paths come from the research of this step. Where a log or output held no direct record, the finding says so.

### A. Ship archives before CI passes (rows 1 and 2)

1. The step blocked three times because it could not edit code to fix PR #136.
2. It could not edit because `gate-write` needs `plan/current/design.md`, and the archive had removed it.
3. The archive ran first because the ship order archives before it waits for CI.
4. The chart field `Step CI fixes: allowed` assumed an editable run, and no check tested that against the ship order.
5. The standards define no reopen procedure for an archived run. No hook, check, or driver step verifies PR checks before it accepts `ready`, because the file holds no CI evidence.

Evidence: `plan/postmortems/2026-11-08-archived-step-cannot-fix-ci.md`, `ravintio-ship/SKILL.md` lines 62 to 69. The research did not read the step 6 session log.
Verdict: partly addressed. PR #139 added decision rows and PR #147 makes the queue wait for checks. The ship order has not changed.
Entry: 0000412 (open).
Guard widening: none if ship waits for green CI before it archives. The reopen option would widen `gate-write`. It would allow a code write when `plan/current/design.md` is absent and a matching `plan/_archive/{feature-id}-*/design.md` or a restore marker exists. Prefer the first option.

### B. The driver misses a block in the final reply (row 3)

1. The driver resumed the session twice because it saw no block.
2. It reads blocks only from the build log, and the step could not write the log.
3. The step reported the block in its reply with an `I-D Advance:` prefix, and `blockIn` rejects a prefix before `Blocked:`.
4. The continue prompt names a file that no longer exists after the archive.
5. No test checks the block contract against the reply forms that standards tell steps to write.

Evidence: `initiative-run.mjs` lines 194 and 400 to 416.
Verdict: unaddressed. The code has not changed.
Entry: 0000413 (open).
Guard widening: none. The driver would stop more often. It is not a fail-closed guard.

### C. Local tests depend on the host (row 4)

1. CI failed two jobs because the runner has no global git identity and Windows PowerShell 5.1 writes a BOM.
2. The local run passed because the machine has a global identity and the run used `pwsh` only.
3. Test workspaces inherit the host git config.
4. The suite has no mode that removes the global config and no fixture with a BOM.
5. The local P3 and pre-push checks do not compare the local environment with the CI runner.

Evidence: the same postmortem, `tests/helpers/assert.sh` line 305.
Verdict: partly addressed. PR #136 fixed the two defects. The check that would have caught them is absent.
Entry: 0000414 (open).
Guard widening: none.

### D. A tool let git write a commit subject (row 5)

1. The queue stopped because the `commit-msg` hook rejected the base-merge commit.
2. Git's default merge subject ran to 106 characters, over the 72 limit.
3. The queue used git's default text and set no subject.
4. The queue tests ran with no blocking `commit-msg` hook.
5. No standard lists the commits that tools make, so no rule tells a tool to meet `commit-standards.md`. The hook runs after the script picks the text.

Evidence: PR #140, `merge-queue.mjs` step 2, `hooks/commit-msg` line 59.
Verdict: addressed by 0000405 (PR #140). The fix covers the queue's one generated commit. The gap in why 5 stays open for other scripts, and the research found no other script that uses git's default text.
Entry: none. No unaddressed cause remains in a known path.
Guard widening: none. The hook stays blocking.

### E. Shared files collide at every merge (rows 6 and 12)

1. Every other open PR conflicted after each merge. Coordinator PR #140 did the same to five ready steps.
2. Each step edits the same files: the architecture overview, the decisions index, the backlog index, and two `.next-id` counters.
3. The ship and implement skills tell each step to update those files on its own branch.
4. Parallel steps branch at different bases, and the base merge is a text merge that conflicts on append-style files.
5. No tool regenerates these files at merge. `coordinator-pr-check.mjs` checks test scope and not overlap with open step PRs.

Evidence: the 0000392 build log lines 134 to 142, `roadmap-standards.md` line 30. Row 6 rests on the evidence file and the coordinator notes, since no log records it.
Verdict: unaddressed. About six rounds of conflicts cost about an hour each.
Entry: 0000430.
Guard widening: none.

### F. A step merged its own PR outside the queue (row 7)

1. Step 12 merged PR #133 outside the queue, so it got no version, no tag, and a `pending` chart row.
2. A fresh session found a finished step with an open, conflicting PR and treated the merge as its next action.
3. Two rules overlap. The carve-out lets a step squash its own PR, and the standard says the queue merges it.
4. `merge-guard` allows any squash into `initiative/*` and does not read the queue flag.
5. No check compares a merge into `initiative/*` with the queue record.

Evidence: `step-12.attempt-6.log`, PR #141. No log shows why the driver did not queue the earlier `ready` file.
Verdict: unaddressed. PR #141 repaired the one case.
Entry: 0000431.
Guard widening: none. The fix narrows `merge-guard`. It would refuse `--squash` when `RAVINTIO_INITIATIVE_QUEUE=1`. The queue merge must keep working, so a test must cover it.

### G. Steps miss the queue items that name them (rows 8, 19, and 25)

1. Sessions did not act on items that named them.
2. They read the empty worktree queue, or picked an item by folder name, or listed the folders and never read `item.md`.
3. The rule sits in a standard and a decision row. The start prompt reads only "Run initiative step {n}".
4. The driver gives the root path in a variable and does not list the items that name the step.
5. No check compares the items that name a step with the commits it raises, so a missed item passes P3 and ship.

Evidence: `step-13.attempt-*.log`, `step-17.log` line 28, `step-18.log`, and the item that still sits in `plan/.initiative-queue/narrow-brand-guard-self-entry/`. No log shows which instruction step 13 missed.
Verdict: row 8 partly addressed by PR #139, which fixed the wrong path. Row 19 partly addressed by PR #147, which landed the files. Row 25 unaddressed. Row 25 also leaves the brand guard allowlist row `^(src/)?ravintio-zero/tests/brand-guard-allowlist\.txt$` with `.` in both copies at line 87. No decision row approved that standing widening.
Entries: 0000425 for discovery and the ship check. 0000432 for the queued instruction.
Guard widening: none. Entry 0000432 narrows the brand guard to an exact-path skip. The human chooses whether the skip covers both copies.

### H. The ready file has no writer or check (rows 9 and 10)

1. The driver stopped with "invalid ready file" for step 9 and for step 20.
2. Step 9 wrote a timestamp and step 20 left the file empty. The driver accepts only a PR number.
3. Each session built the write by hand in a shell line, with no template.
4. The standard describes the file in prose and the pack ships no helper.
5. The driver reads `ready` only after the step ends, so a bad value costs a full stop.

Evidence: `step-9.attempt-8.log`, `step-20.log`, `initiative-run.mjs` lines 818 to 833. No log shows the value of `RAVINTIO_INITIATIVE_CONTROL` for step 20.
Verdict: unaddressed.
Entry: 0000424.
Guard widening: none.

### I. GitHub lags behind the version push (row 11)

1. The merge failed because GitHub refused a squash merge straight after the version push.
2. GitHub had not yet computed mergeability for the new head.
3. The queue called `gh pr merge` right after its CI wait, with no check of the head or the merge state.
4. The queue design modelled GitHub as instant.
5. The test fakes answered `gh` at once, so no test ran against a GitHub that lags.

Evidence: `0000411-queue-waits` discovery line 27, `merge-queue.mjs` lines 90 to 135.
Verdict: addressed by 0000392 (PR #134) and 0000411 (PR #147). A second refusal after the one retry still stops the queue.
Entry: 0000400 (open) covers the related test gaps. No new entry.
Guard widening: none.

### J. A failed queue run leaves state behind (rows 13 and 14)

1. The next merge conflicted on the version rows. Later, a restart could not check out a step branch.
2. A failed run left a version commit on the step branch, and the queue worktree stayed on a step branch.
3. The queue pushes its version commit before the merge, and it switches to the step branch and never leaves it.
4. The rerun rule skips the edits only when the old commit matches the new version. The driver detaches the queue worktree only at the start of the next queue run.
5. Branch ownership has two owners that never check each other. The design forbids rewriting pushed history and offers no other recovery. No test covers the restart path.

Evidence: `merge-queue.mjs` lines 392 to 416, `initiative-run.mjs` lines 773 to 802, the 0000385 and 0000392 build logs. The research found no log line for row 14, so the restart sequence comes from the code and the coordinator notes.
Verdict: unaddressed. Coordinators resolved each case by hand.
Entry: 0000429. Entry 0000400 (open) adds a test for the rerun branch only.
Guard widening: none.

### K. CI duration has no standing measure (row 15)

1. Each merge waited about 16 minutes for CI.
2. The slowest runner ran suites in series, and the `.ps1` suites ran on three runners.
3. Three features each added a CI job for their own need, and none reviewed the whole.
4. The test runner could not split suites, and no standard sets a CI time target.
5. No metric tracks CI duration, and the queue waits twice per merge.

Evidence: `0000409-ci-shards` discovery lines 25 to 31 and build log line 93.
Verdict: partly addressed by 0000409 (PR #144, ADR-0284). Shards cut CI to 4m40s. The 7-minute target was a one-off criterion.
Entry: 0000436.
Guard widening: none.

### L. Ready PRs wait while the driver has stopped (row 16)

1. Ready, green PRs sat idle during driver stops.
2. Merging runs only inside the driver queue task, and the driver exits when its steps finish.
3. After a queue failure the driver holds back every ready PR, including independent ones.
4. The initiative skill says to report the stop and ask, and it describes no merge route.
5. The standards define the manual `merge-queue.mjs run` for the non-concurrent route only.

Evidence: `initiative-run.mjs` lines 1105 to 1108, `roadmap-standards.md` lines 510 to 523.
Verdict: unaddressed. The coordinator rule lives in a memory note outside the pack.
Entry: 0000426.
Guard widening: none. The manual route runs `merge-queue.mjs`, so `merge-guard` allows it.

### M. The coordinator has no status view or event notice (rows 17, 23, and 26)

1. The coordinator missed a ready line for 24 minutes and a driver exit for two hours. It gave a wrong status twice. The human found the run hard to oversee.
2. No monitor ran at the time, and statements rested on the last lines seen.
3. A host monitor expires after 30 minutes. The driver prints a generic "Stopping" line and gives the queue failure reason only at exit.
4. The watcher prints no event for a new `ready` file or a driver exit. The report format lists topics and does not separate a decision from a routine fix.
5. No tool prints one status view, and no rule requires a check against one before a status claim.

Evidence: `initiative-watch.mjs` header, `initiative-run.mjs` lines 999 to 1012, `ravintio-initiative/SKILL.md` lines 47 to 66. The research could not verify the delays or the human quotes from the logs. The log count shows 81 attempt logs. Step 18 has 10, step 13 has 9, step 9 has 8, and steps 6, 8, 12, and 16 have 6 each.
Verdict: unaddressed.
Entry: 0000428.
Guard widening: none.

### N. The driver cannot run the approved setup command (row 18)

1. The driver exited four times, and each exit needed a coordinator restart.
2. Each step changed a setup path, and the driver treats that as a stop.
3. The driver cannot run a command. It prints a stop.
4. The design puts the `Confirmation:` row in the chart for the coordinator to run.
5. The pack has no rule on which approved commands a script may run.

Evidence: `roadmap-standards.md` lines 366 to 380, `initiative-run.mjs` lines 643 to 658. The driver output that shows four stops is not in the logs.
Verdict: unaddressed.
Entry: 0000427.
Guard widening: none. Setup rewrites hook wiring, so the human decides. The driver would run the exact command only.

### O. The version list can go stale (row 20)

1. The queue bump failed CI because it set the installed `component.yml` and not the source copy.
2. `version-files.txt` named only the installed path.
3. The layout move in 0000397 changed where a version file lives and left the list alone.
4. The move tests asserted the exact list and not that the list names every version-carrying file.
5. No check ties the list to the real files. The step also patched the version by hand first, which hid the cause.

Evidence: `0000420-version-both-copies` discovery, PR #150, PR #151.
Verdict: addressed by 0000420 (PR #151) for the stale entry. No fix covers the class.
Entry: 0000433. Entry 0000419 (open) is the nearest and covers test impact for layout moves.
Guard widening: none.

### P. A plan reads shared files too early (row 21)

1. The new suite did not finish because the queue waited for checks that the test fake never reported.
2. The fake matched the script as it stood before step 16 merged.
3. The plan took its source from an earlier read.
4. Parallel steps change shared scripts within minutes.
5. The plan standard has no step that rereads the files a unit edits at the branch point.

Evidence: `plan/postmortems/2026-11-09-queue-test-fake-missed-ci-wait.md`, which sets the preventive action to "none". The research did not open commit 5e3a46f0.
Verdict: unaddressed.
Entry: 0000435.
Guard widening: none.

### Q. Repeated shell tasks have no guidance (row 22)

1. Time went on commands that failed or did the wrong thing.
2. The coordinator wrote zsh commands in bash style and built variable-driven loops that the fail-closed guards cannot read.
3. The guards block `$`, quotes, and merge text by design, and offer the Write tool as the only advice.
4. No pack file says how a coordinator runs repeated or multi-PR commands, and the coordinator skill names no shell.
5. No script covers the repeated tasks. The advice sits in separate build reports (0000316, 0000317, 0000405) and has not reached a standard.

Evidence: `merge-guard.mjs` lines 1 to 30 and 80 to 110, `block-forced-add.mjs` header. The research found no log of the zsh or `replace` snags.
Verdict: unaddressed.
Entry: 0000437.
Guard widening: none. Allowing variables, compound commands, or quoting in either guard would weaken it, so the fix must not do that.

### R. No check reads the clock for reply times (row 24)

1. Reply times ran up to an hour off.
2. Sessions wrote the time from memory or an old reading.
3. The injected time is context only, and the reply rule does not say to read the clock each time.
4. `check-reply-prefix.mjs` accepts any `hh:mm` and checks the shape only.
5. No check compares reply times with the clock, so relays pass wrong times without a signal.

Evidence: `step-15.log`, `check-reply-prefix.mjs` lines 15 and 16. The research could not compare step 14 or step 19.
Verdict: unaddressed. Entry 0000402 covers phase start times, not reply times.
Entry: 0000434.
Guard widening: none. A stricter check rejects a time that differs from the clock.

### S. The add-step helper writes a bare feature id (row 27)

1. The driver stopped with "step 22 has an invalid feature id".
2. The chart cell held `0000421`, and the driver needs `0000421-initiative-retrospective`.
3. `initiative-add-step.mjs` writes the id as `reserve-id.mjs` returns it.
4. The script and the driver each define the id shape and share no pattern.
5. No test runs a chart that the script wrote through the driver pattern.

Evidence: `initiative-add-step.mjs` lines 107, 108, and 143, `initiative-run.mjs` lines 199 and 977. The driver output is not in the logs.
Verdict: unaddressed. A person fixed the chart row by hand.
Entry: 0000423.
Guard widening: none.

## What helped

- Pre-approved decision rows let steps carry on through known forks (PR #139, `initiative.md` decision rows).
- Merge-time versioning gave each step a version in merge order (`0000378-merge-time-versioning`, tag `v0.77.0` for step 21).
- Blameless postmortems named a cause for most stops within a day (`plan/postmortems/`, 13 records from 2026-10-31).

## What slowed the work

- Steps ended at a stop that a person or the coordinator then repaired, such as rows 9, 10, 11, and 18 (`coordinator-evidence.md`).
- Shared files forced about six rounds of conflicts (finding E).
- The coordinator carried workarounds in a memory note and not in the pack (finding L).

## Initiative questions

1. Charted versus shipped (steps, bumps, versions): the chart held 21 steps and all merged. The human added step 22 after the chart. Step 20 moved the pack source into `src/`, which made the version list stale (finding O).
2. Friction that repeated across steps: queue items missed (G), shared file conflicts (E), and routine stops (H, N).
3. Each stop and how long each step took: the 27 rows list the stops. The research found no durations for most steps. Step 6 held five ready PRs for about seven hours. Step 13 wrote `ready` four times without a merge.
4. Initiative tooling gaps: findings B, E, F, G, H, J, L, M, N, and S.

## Keep

- Decision rows written at chart time (PR #139).
- One evidence file that lists each stop with its evidence (`plan/_archive/0000360-backlog-sweep-initiative-2026-11-13/coordinator-evidence.md`).
- Merge-time versioning through the queue.

## Change

- Move routine repairs from the human and the coordinator into the driver and the queue. Findings H, J, L, and N hold the main cases.
- Make the step handover explicit: a helper for `ready` (H), a list of queue items in the start prompt (G), and a status view (M).

## Suggested step order

The coordinator charts these as steps 23 onward. Entries 0000412, 0000413, 0000414, and 0000400 existed before this step. Steps that share a lane run one at a time.

| Step | Entry | Lane | After | Note |
|------|-------|------|-------|------|
| 23 | 0000423 | chart-scripts | 22 | |
| 24 | 0000413 | driver | 22 | |
| 25 | 0000424 | driver | 24 | |
| 26 | 0000425 | driver | 25 | |
| 27 | 0000426 | driver | 26 | |
| 28 | 0000427 | driver | 27 | Human confirms the change. |
| 29 | 0000428 | driver | 28 | |
| 30 | 0000412 | ship | 22 | The reopen option widens `gate-write`. Approve it on its own. |
| 31 | 0000429 | queue | 22 | |
| 32 | 0000430 | queue | 31 | |
| 33 | 0000431 | guard | 31 | Narrows `merge-guard`. |
| 34 | 0000432 | tests | 22 | Narrows the brand guard. Human picks the scope. |
| 35 | 0000414 | tests | 34 | |
| 36 | 0000400 | tests | 31, 35 | |
| 37 | 0000433 | tests | 36 | |
| 38 | 0000434 | hooks | 22 | |
| 39 | 0000435 | plan-skill | 22 | |
| 40 | 0000436 | ci | 22 | |
| 41 | 0000437 | initiative-skill | 29 | Must not widen `merge-guard` or `block-forced-add`. |

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Write the full feature id in add-step | pack maintainer | `scripts/initiative-add-step.mjs` | a test against the driver pattern | 0000423, which names this retrospective |
| Read blocks from the reply | pack maintainer | `scripts/initiative-run.mjs` | a driver test | 0000413 (open) |
| Helper for the ready file | pack maintainer | `scripts/` | a driver and helper test | 0000424, which names this retrospective |
| Steps find their queue items | pack maintainer | driver start prompt and ship skill | a ship check | 0000425, which names this retrospective |
| Merge ready PRs after a stop | pack maintainer | `scripts/initiative-run.mjs` | a driver test | 0000426, which names this retrospective |
| Driver runs the approved setup command | pack maintainer | `scripts/initiative-run.mjs` | a driver test | 0000427, which names this retrospective |
| Status view and event notices | pack maintainer | driver, watcher, initiative skill | a watcher test | 0000428, which names this retrospective |
| Wait for CI before archive | pack maintainer | ship skill | a ship test | 0000412 (open) |
| Queue failure recovery | pack maintainer | `scripts/merge-queue.mjs` | a restart test | 0000429, which names this retrospective |
| Regenerate shared files at merge | pack maintainer | queue and `scripts/coordinator-pr-check.mjs` | a merge test | 0000430, which names this retrospective |
| Refuse a step merge outside the queue | pack maintainer | `hooks/enforcement/merge-guard.mjs` | a hook test | 0000431, which names this retrospective |
| Narrow the brand guard self-entry | pack maintainer | `tests/brand-guard.sh` | a guard test | 0000432, which names this retrospective |
| Tests without a git identity | pack maintainer | `tests/helpers/` | a CI run | 0000414 (open) |
| Cover the queue rerun branches | pack maintainer | `tests/` | a queue test | 0000400 (open) |
| Check the version list | pack maintainer | `tests/` | a test | 0000433, which names this retrospective |
| Check reply times | pack maintainer | `hooks/` | a hook test | 0000434, which names this retrospective |
| Reread files at the branch point | pack maintainer | plan skill | a plan test | 0000435, which names this retrospective |
| Track CI duration | pack maintainer | `scripts/workflow-metrics.mjs` | a metrics test | 0000436, which names this retrospective |
| Coordinator shell guidance | pack maintainer | initiative skill | a review | 0000437, which names this retrospective |
