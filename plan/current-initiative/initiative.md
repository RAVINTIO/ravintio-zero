---
title: "Initiative: 0000349 - clean initiative history"
summary: "Initiative branches deliver N + 1 commits, each step titled with its feature title, and steps run to the end safely without help."
status: "active"  # proposed | charted | active | delivered | blocked
---
# Initiative: 0000349 - clean initiative history

**Goal:** A delivered initiative branch holds one squash per step, titled `{feature-id}: {Feature title} (#{n})`, then one `{initiative-id}: Initiative admin (#{n})` commit. Nothing force-pushes, and step sessions run to the end with no help.
**Branch:** initiative/0000349-clean-initiative-history
**Status:** active
**Position:** 6
**Step CI fixes:** allowed, for a fix inside the step's own scope

## Stop conditions

- Any step prints `Blocked:`.
- CI fails on a coordinator PR. CI fails on a step PR and the fix falls outside the step's scope.
- A step proposes a destructive change.
- A hook fails to run after a setup rerun.
- The setup command at a `Setup:` stop differs from the command that `custom-006` approves.
- A reshape replay at I-E Delivery conflicts.

## Setup stops

| After step | Stop | Why |
|------------|------|-----|
| 1 | `Setup:` | The step changes the ship skill and the initiative template. |
| 2 | `Restart:` and `Setup:` | The step changes the initiative skill and `reserve-id.mjs`. |
| 3 | `Restart:` and `Setup:` | The step changes the initiative and ship skills and adds a script. |
| 4 | `Restart:` and `Setup:` | The step changes the driver, the watcher, the orchestrator skill, the initiative template, and setup. |
| 5 | `Setup:` | The step changes the validate-and-accept and plan skills, and changes the workflows. |
| 6 | `Setup:`, then a check that every hook runs | The step changes the hooks, the hook commands setup writes, and the Codex adapter. |
| 7 | `Setup:` | The step changes the phase skills, the reply prefix hook, the `CLAUDE.md` template, and the test runner. |
| 8 | `Setup:`, before I-E Delivery | The step changes the dispatch standard and the orchestrator and implement skills. |

## Schema changes

**Unpredicted additive changes:** stop

| Step | Component | Change | Kind |
|------|-----------|--------|------|
| 1-8 | none | none. Every step changes pack files, scripts, tests, or CI. No step touches a data contract. | none |

## Dependencies

| Step | Name | Kind | Purpose |
|------|------|------|---------|
| 1-8 | none | none | No step adds a library or a service. CodeQL runs as a GitHub action, not a dependency of the pack. |

## Decisions

| Step | Fork | Pre-approved answer | Bump effect |
|------|------|---------------------|-------------|
| 1-8 | Confirmation: setup rerun at each `Setup:` stop | Run the exact command `ravintio-zero/setup.sh claude-code --strict-orchestrator`, as override `custom-006` approves. If the command differs in any way, stop for the human. | none |
| 1 | The step commit title form (entry 0000350) | `{feature-id}: {Feature title} (#{n})`. The chore commit is `{initiative-id}: Initiative admin (#{n})`. The human chose this on 2026-11-01. | none |
| 1 | Feature brief titles vary in case | The title comes from the `Title` column of `## Steps`, in sentence case. The check compares it exactly. | none |
| 1 | Delivered history on `main` uses the old title form | The check reads only the commits between the PR base and head. It never rechecks delivered history. | none |
| 1 | The step changes the chart format (entry 0000268) | Add the `Title` column to `plan/current-initiative/initiative.md` in the same step. Also add the entry 0000268 rule: a step that changes a chart format updates the active chart. Touch the archived 0000312 chart only if a test reads it. | none |
| 2 | Admin work that aligns with a running step | Queue it in `plan/.initiative-queue/` with the step named. The step session commits it on its feature branch before P4 raises the PR. | none |
| 2 | `reserve-id.mjs --commit` runs on `initiative/*` (entry 0000332) | The script refuses and names the `feat/` route. | none |
| 2 | The coordinator squash command | `gh pr merge --squash --delete-branch {n}`, the form ship uses. `merge-guard` already allows it. | none |
| 3 | Where the reshape lands | A new branch, `initiative/{id}-{slug}-reshaped`. The coordinator raises the initiative PR from it, closes any PR from the old branch, and deletes the old branch after the human merges. Nothing force-pushes. The human set this on 2026-11-01. | none |
| 3 | How step tags move | Delete the old tag on `origin`, then push a new tag with the same name and message at the reshaped commit. Never force-push a tag. The human set this on 2026-11-01. | none |
| 3 | Step titles on the reshaped branch | The reshape writes each step title from the `Title` column, so a step that shipped before step 1's rule still lands with the right title. | none |
| 3 | Ship's `## PRs into main` lets `chore/*` force-push with a lease | Change it to the `hotfix/*` route: build one commit on a new branch, raise a replacement PR, close the old one, and delete the old branch. Remove the `--force-with-lease` allowance. This narrows a written rule. May also change `ravintio-zero/skills/ravintio-ship/SKILL.md` and its tests. | none |
| 3 | A replay conflicts | Stop for the human. Never drop a hunk. | none |
| 4 | The resume cap for a step that exits 0 unmerged (entry 0000334) | Resume up to two times with `claude -p --resume {session}`. If it exits 0 unmerged after the second resume, print `Blocked:` and exit 1. The human set two resumes on 2026-11-01. | none |
| 4 | How setup avoids timestamp churn (entry 0000343) | Leave the tracked record unchanged when only `writtenAt` would change. Keep the record in place. | none |
| 4 | `setup.ps1` parity | Change `setup.ps1` in the same step. | none |
| 4 | The resume adds a driver argument (entry 0000256) | Move the expected arguments into one helper in `ravintio-zero/tests/helpers/` first, then add the resume. | none |
| 4 | The watcher finds no build log (entry 0000270) | Print `waiting for the build log` and skip the stale check. Take the step number from the driver lock or step log name. | none |
| 4 | Whether a step may fix its own CI failure (entry 0000344) | Add a `**Step CI fixes:**` field to the chart template, `allowed` or `stop`, default `stop`. This initiative sets `allowed` for a fix inside the step's own scope. | none |
| 5 | CodeQL needs advanced setup to scan PRs into `initiative/**` (entry 0000346) | Add `.github/workflows/codeql.yml` for JavaScript and GitHub Actions, on PRs into `main` and `initiative/**`. If the human must turn default setup off in repo settings, the step stops for the human before it merges. | none |
| 5 | Entry 0000323 says CodeQL is not configured and asks the developer to turn on branch deletion | Update entry 0000323 in the same step: CodeQL now runs from the workflow, and the branch deletion item goes. | none |
| 5 | Where the branch cleanup job lives (entry 0000356) | Add it to `ravintio.yml`, the workflow setup already installs, on `pull_request` `closed`. Every existing job skips the `closed` event. If that guard can't hold for a job, use a separate workflow file that setup installs, in `setup.sh` and `setup.ps1`. | none |
| 5 | The cleanup job's token scope | `contents: write` on that job only. Every other job keeps its current permissions. The security review covers the job. | none |
| 5 | A new workflow breaks a workflow-shape test (entry 0000338) | Make the job list in `test-0000169-req-006` read a marker comment on each job, then add the CodeQL workflow. | none |
| 6 | How a hook fails closed with no launcher (entry 0000340) | Setup writes each hook command so that a missing `guard-run.mjs` exits 2 with a message. Change `setup.ps1` in the same step. | none |
| 6 | Forced-add forms the guard can't parse (entry 0000341) | Block `git stage -f`, subshells, and flags in variables. Block any segment the guard can't parse, as `merge-guard` does. This tightens the guard. | none |
| 6 | Codex has no forced-add guard (entry 0000341) | Add it to the Codex adapter. If the Codex hook model can't express it, file a backlog entry and carry on. The CI ignored-file check stays as the backstop. | none |
| 6 | Where the prefix-misses log is ignored (entry 0000342) | Add `plan/.prefix-misses.log` to the `.gitignore` setup writes and to this repo's `.gitignore`. | none |
| 7 | The status for a routine question (entry 0000273) | Add `Question` to the status set. `Blocked:` stays for exception stops only. Resume detection and the governance counts keep reading `Blocked:` unchanged. | none |
| 7 | Where the status set lives | Change the orchestrator, the phase skills, the `CLAUDE.md` setup writes, this repo's `CLAUDE.md`, and the comment in `check-reply-prefix.mjs`. The hook only warns, so no fail-closed guard changes. | none |
| 7 | Build log times (entries 0000266 and 0000335) | Every phase reads `date -u +%Y-%m-%dT%H:%M:%SZ` and never types a time. `build-log-check.mjs` fails a time later than the commit that adds it, and a closed phase block with no `Complete:` or `Skipped:` line. | none |
| 7 | The failing suite list (entry 0000269) | `run-tests.sh` and `run-tests.ps1` print each failed suite's file name under the totals, even with `RAVINTIO_TEST_QUIET=1`. | none |
| 8 | Git commands while subagents run (entry 0000331) | The step session never runs `git stash`, `git checkout -- {path}`, `git reset`, or `git clean` while any subagent runs. It tests a clean tree in a scratch clone. | none |
| 8 | Parallel track commits (entry 0000336) | Each unit commits with `git commit -m "{message}" -- {paths}`. No `git commit --amend` in a batch. | none |
| Delivery | This initiative's own delivery | Use the step 3 reshape. If it fails, stop for the human. | none |

## Baselines

| Step | Target | Baseline | Source |
|------|--------|----------|--------|
| 1-8 | none | No step has a speed or size target. | none |

## Criteria

| Step | Criterion | Noise and margin | Checked in |
|------|-----------|------------------|------------|
| 1 | `check-initiative-history.mjs` passes a fixture with N titled steps and one chore commit. It fails a fixture with a mistitled step, and one with an extra commit between steps. | Deterministic | local |
| 2 | `reserve-id.mjs --commit` exits non-zero on an `initiative/*` branch and commits nothing. | Deterministic | local |
| 2 | Every coordinator squash command in the pack names `--delete-branch`. | Deterministic | local |
| 3 | On a fixture branch, the reshape gives N + 1 commits on a new branch. The last tree equals the old head, and every step tag points at its new commit. No command in the script uses `--force`. | Deterministic | local |
| 4 | With a fake `claude` that exits 0 unmerged, the driver resumes two times, then prints `Blocked:` on the third exit. | Deterministic | local |
| 4 | Running setup twice leaves a clean `git status`. | Deterministic | local |
| 4 | With no `plan/current/build-log.md`, the watcher prints no stale line. | Deterministic | local |
| 4 | The three driver suites from entry 0000256 read their arguments from one helper. | Deterministic | local |
| 5 | CodeQL runs on a PR into `initiative/**`. | Needs GitHub. The step's own PR shows it. | CI |
| 5 | The P3 security review checklist names incomplete escaping. | Deterministic | local |
| 5 | A new workflow job with the marker comment needs no edit to `test-0000169-req-006`. | Deterministic | local |
| 5 | After the step's own PR merges into the initiative branch, its head branch is gone from `origin`. A fork head and `main` are never deleted. | The merge needs GitHub. The fork and `main` skips are checked in the template. | CI and local |
| 6 | With `guard-run.mjs` removed, a guarded call is blocked, not allowed. | Deterministic | local |
| 6 | `git stage -f`, `(git add -f x)`, and a flag in a variable are each blocked. | Deterministic | local |
| 6 | A fresh clone treats `plan/.prefix-misses.log` as ignored. | Deterministic | local |
| 7 | The orchestrator status set names `Question`, and the skills reserve `Blocked:` for exception stops. | Deterministic | local |
| 7 | `build-log-check.mjs` fails a fixture with a future time and one with an open phase block. | Deterministic | local |
| 7 | With one failing suite, `run-tests.sh` names it after the totals, with and without `RAVINTIO_TEST_QUIET=1`. | Deterministic | local |
| 8 | The orchestrator skill names the git commands a step never runs while subagents run. The dispatch standard names the `-- {paths}` form and the amend ban. | Deterministic | local |
| Delivery | The initiative PR into `main` shows 8 step commits titled from the `Title` column, then one admin commit. | Deterministic | CI |

## P1 skips

| Step | Skip P1 | Reason |
|------|---------|--------|
| 1 | no | The step changes a script, a template, and ship. |
| 2 | no | The step changes a script and the initiative skill. |
| 3 | no | The step adds a script and changes two skills. |
| 4 | no | The step changes the driver, the watcher, and setup. |
| 5 | no | The step changes workflows, a test, and two skills. |
| 6 | no | The step changes hooks and setup. |
| 7 | no | The step changes skills, a hook, a script, and the test runner. |
| 8 | no | The step changes skills and a standard, with tests. |

## Steps

| Step | Feature id | Title | Backlog entries | Bump | Version | Status |
|------|------------|-------|-----------------|------|---------|--------|
| 1 | 0000351-step-titles-and-history-shape | Step titles and history shape | 0000350, 0000339, 0000345 (rule 4), 0000268 | minor | 0.49.0 | merged |
| 2 | 0000352-coordinator-admin-in-step-prs | Coordinator admin in step PRs | 0000345 (rules 1, 2, and 5), 0000332 | minor | 0.50.0 | merged |
| 3 | 0000353-reshape-at-delivery | Reshape at delivery | 0000345 (rule 3) | minor | 0.51.0 | merged |
| 4 | 0000354-steps-run-to-the-end | Steps run to the end | 0000334, 0000343, 0000256, 0000270, 0000344 | minor | 0.52.0 | merged |
| 5 | 0000355-codeql-and-branch-cleanup | CodeQL and branch cleanup in CI | 0000346, 0000338, 0000356 | minor | 0.53.0 | merged |
| 6 | 0000357-guard-gaps-closed | Guard gaps closed | 0000340, 0000341, 0000342 | minor | | pending |
| 7 | 0000358-clean-step-stops-and-logs | Clean step stops and logs | 0000273, 0000266, 0000335, 0000269 | minor | | pending |
| 8 | 0000359-safe-parallel-commits | Safe parallel commits | 0000331, 0000336 | minor | | pending |
