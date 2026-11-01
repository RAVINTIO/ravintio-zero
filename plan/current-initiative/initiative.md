---
title: "Initiative: 0000312 - guards, history, and test noise"
summary: "Clears 17 backlog entries in 10 feature steps, with a setup rerun after each step that changes installed pack files."
status: "active"
---
# Initiative: 0000312 - guards, history, and test noise

**Goal:** Make the guards fail closed, keep every initiative history titled one commit per change, and stop step logs and session state breaking the suite. Step 1 teaches the driver to stop for a setup rerun, so each later step runs on installed copies that match the pack.
**Branch:** initiative/0000312-guards-history-and-test-noise
**Status:** active
**Position:** 7
**Speed:** fast

The human asked for this draft on 2026-10-31 and confirmed the scope and order the same day. Chart ran on 2026-10-31 on branch `feat/0000312-chart`, cut from `main` after PR #77 landed.

## Parallel work in each step

The human chose `fast` on 2026-10-31 and asked for independent work to run in parallel. Each step follows these rules:

- Dispatch independent units, such as requirements, files, reviews, and searches, as parallel subagents in one message.
- Run units in sequence only when one unit needs another's output, or when two units write the same file.
- If a step runs a unit in sequence, the build log names the dependency that forced it.
- Each subagent stages only the paths it wrote, by explicit path.

The steps themselves run one at a time. The driver supports one step per working tree, and the setup stops and the guard work before step 6 depend on that order.

## Notes for chart

- **Ids reserved.** Commit `7d3f0b3` reserved `0000311` to `0000321` on 2026-10-31. Entry 0000311 took the first id. This draft uses `0000312` for the initiative and `0000313` to `0000321` for steps 1 to 9. Commit `f72777d` reserved `0000326` for entry 0000326 and `0000327` for step 10.
- **Setup stops.** Step sessions load the installed copies in `.claude/`. Setup writes only ignored files, so a rerun needs a pause between steps, not a step or a commit. Step 1 adds a `Setup:` stop to the driver (entry 0000311). After it, the initiative skill reruns setup with the command that override `custom-006` approves, checks that every hook runs, and starts a new driver. See `## Setup stops`.
- **Step 1 runs on the old driver.** The driver loaded its code at activation, so step 1 ends with a `Restart:` stop. At that stop, the initiative skill reruns setup by hand with the same command, then starts the new driver.
- **Clean suite first.** Steps 2 and 3 remove the test noise that cost a note or a rerun in nine retrospectives, 0000245 to 0000253. Later steps then run on a clean suite.
- **Guards before history.** Steps 4 and 5 make the guards fail closed before step 6 changes how the coordinator commits.
- **Coordinator change mid-run.** Step 6 (entry 0000274) changes the initiative skill and the roadmap standards. See `## Coordinator PRs`.
- **Tracked workflow.** Setup writes `.github/workflows/ravintio.yml` only when it is missing (`setup.sh:729`). Step 7 must change the tracked copy in the same step as the pack's copy.
- **Security guards.** No entry widens `merge-guard`, `gate-write`, `ratchet-check`, or another fail-closed hook. Entries 0000276 and 0000288 make guards stricter. Entry 0000274 keeps `merge-guard` as it is. Entry 0000322 changes an advisory hook that always exits 0.
- **New force-push permission.** Entry 0000326 lets the agent run `git push --force-with-lease` on its own `chore/*` branch. No hook blocks a force-push today, so this widens no guard. The human approved it on its own on 2026-10-31, for `chore/*` branches only. A `hotfix/*` branch gets a replacement PR instead.
- **Clarity check.** Entry 0000267 had no **Wanted outcome** section. The human approved the added section on 2026-10-31 (commit `3417f4c`). Every pulled-in entry now has one.
- **Retrospective input.** The latest records, 0000238 and 0000253, filed changes that stay open outside this initiative: entries 0000266, 0000268, 0000269, 0000270, and 0000271. Entries 0000265 and 0000267 are in step 2 and step 3.

## Coordinator PRs

The human decided on 2026-10-31 that nothing commits directly on the initiative branch. Every coordinator change reaches `initiative/0000312-guards-history-and-test-noise` as a titled PR with green CI.

- Coordinator work covers the activation, queued backlog entries, scope edits, and the I-E Delivery archive and retrospective.
- Each coordinator PR has a title of the form `0000312-guards-history-and-test-noise: {summary} (#{n})`.
- The full suite passes locally before the PR opens.
- CI passes on the PR before the agent squash-merges it.
- The coordinator raises a PR only while the driver is stopped, such as at a `Setup:` or `Restart:` stop. While a step runs, the coordinator queues work in `plan/.initiative-queue/`.

`merge-guard` already allows a squash into `initiative/*`, so the hook needs no change. The written carve-out in `roadmap-standards.md` names only the agent's own feature PR after a clean P3. Step 6 adds coordinator PRs that meet the bar above. The hook keeps its current behaviour, and step 6 tests that it allows exactly what it allows today.

## History check

Step 7 (entry 0000275) adds a script that reads the first-parent titles of an initiative branch. It fails on any title that doesn't match `{7-digit id}-{slug}: {summary} (#{n})`.

This initiative applies the coordinator PR rule from activation, before step 6 writes it into the pack. If every coordinator change follows the rule, the script should find no untitled commit on this branch.

If the script still finds one, it fails. The script has no exception list. Neither this initiative nor any later one may add one. At I-E Delivery, the coordinator runs the script, lists each failing commit in the initiative PR body, and stops. The human decides at the initiative PR.

## Stop conditions

- Any step prints `Blocked:`.
- CI fails on a step PR or a coordinator PR.
- A step proposes a destructive change.
- A hook fails to run after a setup rerun.
- The setup command at a `Setup:` stop differs from the command that `custom-006` approves.

## Setup stops

| After step | Stop | Why |
|------------|------|-----|
| 1 | `Restart:`, then a setup rerun by hand | The step changes the driver and the initiative skill. |
| 2 | `Setup:` | The step changes the orchestrator and initiative skills. |
| 3 | none | The step changes tests and the test runner only. |
| 4 | `Setup:`, then a check that every hook runs | The step changes `setup.sh` and how setup wires hooks. |
| 5 | `Setup:` | The step adds a hook. |
| 6 | `Restart:` and `Setup:` | The step changes the initiative skill and other skills. |
| 7 | `Setup:` if the step changes the pack's hooks | The step adds a script and changes CI. |
| 8 | `Setup:` | The step changes two hooks, a script, and the migrator skill. |
| 9 | `Setup:` | The step changes the backlog template and the orchestrator skill. |
| 10 | `Setup:`, before I-E Delivery | The step changes the ship and orchestrator skills and CI. |

## Schema changes

**Unpredicted additive changes:** stop

| Step | Component | Change | Kind |
|------|-----------|--------|------|
| 1-10 | none | none. Every step changes pack files, hooks, scripts, tests, or CI. No step touches a data contract. | none |

## Dependencies

| Step | Name | Kind | Purpose |
|------|------|------|---------|
| 1-10 | none | none | No step adds a library or a service. Entries 0000287 and 0000288 use Claude Code settings, not a library. Entry 0000278 documents a GitHub ruleset that the human applies. |

## Decisions

| Step | Fork | Pre-approved answer | Bump effect |
|------|------|---------------------|-------------|
| 1 | Confirmation: setup rerun at the step 1 `Restart:` stop | Run the exact command `ravintio-zero/setup.sh claude-code --strict-orchestrator`, as override `custom-006` approves. If the command differs in any way, stop for the human. | none |
| 2-10 | Confirmation: setup rerun at each `Setup:` stop | Run the same exact command. If it differs in any way, stop for the human. | none |
| 2 | How the phase guard leaves out step logs (entry 0000264) | Skip `plan/.initiative-logs/` only. Never switch to scanning tracked files only, because that would hide new untracked skill files. | none |
| 3 | A suite fails once the runner clears `RAVINTIO_*` | The suite sets the variable it needs. | none |
| 4 | The Claude Code docs don't confirm `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` or `CLAUDE_PROJECT_DIR` | Stop for the human. | none |
| 4 | The Codex adapter has no project-dir variable | Setup writes the absolute project path into the Codex hook commands. | none |
| 4 | `setup.ps1` parity | Change `setup.ps1` in the same step. | none |
| 4 | A hook fails to resolve or run after the setup rerun | Stop for the human. Never carry on with a guard that doesn't run. | none |
| 5 | Other forms of a forced add | Also block combined short flags, such as `-fA`, and the `git -C {dir} add -f` form. | none |
| 5 | A tracked file matches an ignore rule on purpose | Add a negation rule to `.gitignore`. Never drop the CI check. | none |
| 6 | Widening: the written merge carve-out in `roadmap-standards.md` | Add coordinator PRs that meet the bar in `## Coordinator PRs`. The human approved this on its own on 2026-10-31. `merge-guard` stays unchanged. | none |
| 6 | The step changes the chart format | Update `plan/current-initiative/initiative.md` in the same step, as entry 0000268 asks. | none |
| 7 | The step changes the pack's `ravintio.yml` | Change `.github/workflows/ravintio.yml` in the same step, because setup won't overwrite it. | none |
| 7 | How CI knows a `main` commit came from an `initiative/*` PR | Parse the merge commit message. Add no new token scope. | none |
| 7 | The history check finds an untitled commit on this branch | Follow `## History check`. Add no exception list. | none |
| 8 | The scope of "any other finding" in entry 0000282 | Limit the step to migration findings. Leave the pack-version check to entry 0000272. | none |
| 8 | The host passes no session id to `UserPromptSubmit` hooks | Stop for the human. | none |
| 8, 9 | A new migration applies to this repo | The step that adds the migration applies it and records it. Any later migrator prompt is a human stop. | none |
| 9 | The review age for stale entries (entry 0000310) | 5 days from **Date filed**, read from `product.yml` so each repo can set its own. The human chose this on 2026-10-31. | none |
| 9 | Entries queued during the run lack `priority` and `theme` | I-E Delivery adds the defaults and regenerates the index in its coordinator PR. | none |
| 10 | Widening: `git push --force-with-lease` (entry 0000326) | Allowed on the agent's own `chore/*` branch only. Never on `hotfix/*`, `feat/*`, `main`, or `initiative/*`. The human approved this on its own on 2026-10-31. | none |
| 10 | A `hotfix/*` PR into `main` holds more than one commit | Build one squashed commit on a new branch cut from `origin/main`, raise a replacement PR, and close the old PR with a link. Never force-push. | none |
| 10 | Pack text that tells a run outside an initiative to cut a `feat/` branch | Change it to `hotfix/` in the same step, including the setup source of the generated `CLAUDE.md`. | none |

## Baselines

| Step | Target | Baseline | Source |
|------|--------|----------|--------|
| 1-10 | none | No step has a speed or size target. | none |

## Criteria

| Step | Criterion | Noise and margin | Checked in |
|------|-----------|------------------|------------|
| 1 | A change under `ravintio-zero/skills/` makes the driver print a `Setup:` line and exit 1. A test-only change prints none. | Deterministic | local |
| 2 | `test-0000042-req-006` and `test-0000043-req-009` pass with a populated step log. A planted stale cite in a tracked skill still fails. | Deterministic | local |
| 2 | After a full suite run in a step, `plan/.initiative-logs/` still holds every step log. | Deterministic | local |
| 3 | The suite passes with `RAVINTIO_INITIATIVE_STEP=1` set, as it does without it. | Deterministic | local |
| 3 | `git status` matches before and after a full run. | Ignored driver logs change during a step, so the check reads tracked and untracked files only. | local |
| 3 | `test-0000164-req-007` passes with a freshly generated `CLAUDE.md` and fails when the phrases leave `hook-enforcement.md`. | Deterministic | local |
| 4 | Each hook in `.claude/settings.json` runs from a subfolder. A guard with a missing script exits 2 and names it. Every current block stays blocked. | Deterministic | local |
| 4 | `setup.ps1` writes the same settings on Windows. | Only CI has Windows runners. | CI |
| 5 | The hook blocks `git add -f plan` and `git add --force plan`, and allows `git add plan/current`. | Deterministic | local |
| 5 | The CI check fails a branch with a committed ignored file. | Deterministic | local |
| 6 | The roadmap standards and the initiative skill name no direct commit on the initiative branch. `merge-guard` allows exactly what it allows today. | Deterministic | local |
| 7 | The history script passes titled squashes and fails one direct commit, naming it. | Deterministic | local |
| 7 | CI runs the script on PRs from `initiative/*` to `main`, the `push` trigger includes `initiative/**`, and `release-tag` runs only on `main` and `master`. | Only CI shows the trigger and the job behaviour. | CI |
| 7 | The single-parent check fails a one-parent commit from an `initiative/*` PR and passes a two-parent commit. | Deterministic | local |
| 8 | The load instruction appears once per session id. | Deterministic | local |
| 8 | A false-condition migration appears once per pack version, a `done` migration stays quiet after a pack update, and running a migration leaves `ravintio-zero/` unchanged. | Deterministic | local |
| 8 | The prefix check warns only when the final reply lacks a prefix. | Deterministic | local |
| 9 | The index lists every open entry with its priority and theme. The review lists an entry older than 5 days. | Deterministic, with a fixed clock in the test | local |
| 9 | CI fails when the committed index differs from a fresh run. | Deterministic | local |
| 10 | The CI check fails a `chore/*` or `hotfix/*` PR into `main` with two commits, passes one with one commit, fails any `feat/*` PR into `main`, and ignores `initiative/*`. | Deterministic | local |
| 10 | CI runs the check on PRs into `main`. | Only CI shows the trigger. | CI |

## P1 skips

| Step | Skip P1 | Reason |
|------|---------|--------|
| 1 | no | Changes the driver and the initiative skill. |
| 2 | no | Changes a test guard and two skills. |
| 3 | no | Changes the test runner and tests. |
| 4 | no | Changes setup and how hooks run. |
| 5 | no | Adds a hook and a CI check. |
| 6 | no | Changes skills and the roadmap standards. |
| 7 | no | Adds a script and changes CI. |
| 8 | no | Changes hooks, a script, and the migrator skill. |
| 9 | no | Changes the backlog template, a skill, and CI. |
| 10 | no | Changes the ship skill and CI. |

## Steps

| Step | Feature id | Backlog entries | Bump | Version | Status |
|------|------------|-----------------|------|---------|--------|
| 1 | 0000313-driver-setup-stop | 0000311 | minor | 0.41.0 | merged |
| 2 | 0000314-step-logs-stay-in-place | 0000264, 0000265 | patch | 0.41.1 | merged |
| 3 | 0000315-isolated-test-state | 0000309, 0000267 | patch | 0.41.2 | merged |
| 4 | 0000316-hooks-fail-closed | 0000287, 0000288 | minor | 0.42.0 | merged |
| 5 | 0000317-block-forced-adds | 0000276 | minor | 0.43.0 | merged |
| 6 | 0000318-titled-coordinator-prs | 0000274 | minor | 0.44.0 | merged |
| 7 | 0000319-initiative-history-checks | 0000275, 0000277, 0000278 | minor | 0.45.0 | pending |
| 8 | 0000320-quiet-session-start | 0000307, 0000282, 0000322 | minor | 0.46.0 | pending |
| 9 | 0000321-backlog-triage | 0000310 | minor | 0.47.0 | pending |
| 10 | 0000327-squash-before-main | 0000326 | minor | 0.48.0 | pending |

### Step grouping

- **Step 2:** both entries stop step logs in `plan/.initiative-logs/` from breaking or being moved by the suite.
- **Step 3:** both entries stop session state from changing test results.
- **Step 4:** both entries keep the guards working when the working directory moves.
- **Step 7:** all three entries catch an untitled or squashed history before or as it reaches `main`.
- **Step 8:** all three entries stop hook text that repeats or misfires: the load instruction, the migration findings, and the false prefix warning.
- **Step 10:** the entry keeps the history of `main` at one commit per chore or hotfix, now that `main` takes merge commits only. Only `initiative/*`, `chore/*`, and `hotfix/*` branches may target `main`.
