---
title: "Retrospective: 2026-11-27 - priority backlog initiative"
summary: "A blameless review of initiative 0000544, which shipped 38 steps from v0.115.0 to v0.152.0, and the changes it files."
status: "open"  # open | closed
---
# Retrospective: 2026-11-27 - priority backlog initiative

> Path: `plan/retrospectives/{feature-id}-{date}.md` for a run, `plan/retrospectives/{id}-{slug}-initiative-{date}.md` for an initiative. Written by `ravintio-retrospective`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Mode:** initiative
**Subject:** 0000544-priority-backlog
**Date:** 2026-11-27

## Summary

The initiative shipped all 38 charted steps as minor bumps, from v0.115.0 to v0.152.0. The first 30 merges took about 37 hours. Three long stops followed, each caused by a gap in temp folder handling or the step sandbox.

## What helped

- Four concurrent steps kept the merge queue busy. It merged 30 steps between 2026-11-14T17:36Z and 2026-11-16T06:56Z (`## Merges` in the archived `initiative.md`).
- The merge queue renumbered colliding ADR ids by itself. Steps 36 and 37 both reserved ADR 0353, and the queue moved step 37's to 0354 (queue output for PR #255).
- Driver handoff let a step that changed the driver merge without stopping the other sessions (driver log for step 38, PR #252).
- The commit and prose hooks stopped passive voice, long subjects, and unsafe `git add` forms before they reached a PR.

## What slowed the work

- Suite temp folders leaked and filled the disk on 2026-11-14. The coordinator removed 26.1 GiB by hand, and the initiative paused after step 3.
- Step 38's first cleanup removed entries by name in the shared `/tmp`. On 2026-11-18 its driver suites deleted another project's scratch. The run stopped until 2026-11-26 while the human chose a scope (ADR-0352).
- The runner placed its temp folder inside the repo when `TMPDIR` was unset. Suites that expect a folder outside a git repo failed in CI on PR #252 (`plan/postmortems/2026-11-26-runner-temp-folder-inside-repo.md`).
- The step sandbox from step 38 blocked `git push` over SSH and `mktemp`. Steps 36 and 37 finished their work and could not ship. Setup suites then ran with an empty workspace. They committed fixtures into step 36 (55 commits) and step 37 (26 commits). A `grep -rl` from `/` ran for more than 13 hours (PRs #254 and #255, PR #256).
- Claude Code's Bash tool replaces `TMPDIR` with `/tmp/claude-{uid}`. The private `.t` folder from step 38 is never used (ADR-0352 revision).
- Step 36 merged its `plan/current/` folder, because nothing checks for the archive before a merge. The coordinator archived it in PR #257.
- Rule anchors in step 35 broke byte caps and copied into boot templates (`plan/postmortems/2026-11-26-anchor-edits-broke-cap-and-copy-consumers.md`).

## Initiative questions

1. **Charted versus shipped:** all 38 steps shipped, each as a minor bump. Versions follow merge order, not chart order, as the concurrent driver intends. Step 3 shipped first as v0.115.0, and step 37 shipped last as v0.152.0. No step changed scope after the chart. The human recharted step 38 once, on 2026-11-26, to a private temp folder.
2. **Repeated friction:**
   - Temp folder handling caused four separate stops: the disk leak, the shared `/tmp` deletion, the runner folder inside the repo, and the sandbox `mktemp` failure.
   - Full local suite runs did not finish inside tool time limits (`plan/postmortems/2026-11-15-clean-clone-suite-did-not-finish.md`). Steps 36 and 37 also ended with an unfinished local suite.
   - Steps logged TDD markers in batches or out of order. Steps 35 and 36 batched `RED:` and `GREEN:` lines. Step 37 backdated a `RED:` line. Steps 28, 35, 37, and 38 logged `Complete:` before the phase's work. `build-log-check.mjs` accepted each one.
   - Planned pin updates showed up as rework (`plan/postmortems/2026-11-15-planned-pin-update-logged-as-rework.md` and `plan/postmortems/2026-11-16-pin-update-after-renumbering-logged-as-rework.md`).
3. **Stops and step time:**
   - 2026-11-14T17:43Z: a pause for the disk leak. The run resumed on 2026-11-15.
   - 2026-11-16T06:56Z to 2026-11-18T07:35Z: no merge. The archive holds no stop line for this gap, so this record cannot name its cause.
   - 2026-11-18T08:52Z to 2026-11-26T07:04Z: a stop after the shared `/tmp` deletion, until the human chose a scope for step 38.
   - 2026-11-26T11:12Z to 2026-11-27T00:17Z: a stop after steps 36 and 37 could not push. It ended when PR #256 removed the sandbox and the coordinator pushed both branches.
   - Per-step durations are not in this record. The archived build logs hold phase wall clocks for each step. The chart holds only merge times.
4. **Tooling gaps:**
   - The merge queue does not check that a step archived `plan/current/` before the merge.
   - The driver's `TMPDIR` does not reach the Bash tool.
   - Workspace helpers carry on with an empty path when `mktemp` fails.
   - `build-log-check.mjs` reads which markers exist, not their order or time.
   - `initiative-cleanup.mjs` removes worktrees with `--force`.
   - The sandbox settings had no live test before the driver used them.

## Keep

- Keep four concurrent steps with a merge queue that renumbers ids. It merged 30 steps in about 37 hours (`## Merges`).
- Keep coordinator PRs for driver fixes while the driver is not running. PRs #256 and #257 cleared two stops in under an hour.

## Change

- Refuse a step merge while the branch still holds `plan/current/` (PR #254).
- Give step scratch a variable that Claude Code does not replace, and stop suites on an empty workspace (PRs #254 and #255).
- Check marker order and time in the build log (step 35, 36, and 37 logs).
- Keep a worktree with uncommitted or unpushed work at cleanup (`initiative-cleanup.mjs`).
- Test a sandbox setting live before the driver uses it (PR #256).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Queue refuses a step PR with `plan/current/` or no build report | merge queue | `ravintio-zero/scripts/merge-queue.mjs` | Queue suite with fixture heads | Backlog 0000607 |
| `RAVINTIO_STEP_TMP` for step scratch, and suites stop on an empty workspace | driver and test runner | `initiative-run.mjs`, `run-tests.sh`, test helpers | Driver and runner suites | Backlog 0000608 |
| Build log check rejects batched, backdated, and early markers | build log gate | `ravintio-zero/scripts/build-log-check.mjs` | Fixture log suites | Backlog 0000609, naming this retrospective |
| Cleanup keeps a worktree with uncommitted or unpushed work | delivery cleanup | `ravintio-zero/scripts/initiative-cleanup.mjs` | Cleanup suite with fixture worktrees | Backlog 0000610, naming this retrospective |
| Plan scan cause for anchor edits | plan skill | `ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md` | Plan scan suite | Backlog 0000606 |
| A sandbox for step sessions that allows SSH push and the temp folders, tested live | driver | `initiative-run.mjs` | A live probe in a step session | Backlog 0000611, naming this retrospective |
