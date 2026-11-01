---
title: "Backlog Entry: 0000345 - initiative branches hold N + 1 commits"
summary: "A human-requested change, filed for pickup at a future discovery run."
status: "open"
priority: "high"
theme: "initiative-history"
---
# Backlog Entry: 0000345 - initiative branches hold N + 1 commits

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-11-01

---

## Problem

Initiative 0000312 put 13 coordinator squashes between its 10 step squashes. The human asked for a history of one squash per step, so the coordinator rewrote the branch and moved 10 tags before review.

Three rules cause coordinator PRs between steps:

- **Queued entries.** The initiative skill says to move queued entries to `plan/backlog/` after each step merges, through a coordinator PR (PRs #79, #81, and #91).
- **Supervision notes.** The notes file sits in the tracked tree, so each update needs a PR (PRs #88 and #90).
- **Two delivery PRs.** The I-E Delivery rules in `ravintio-zero/standards/roadmap-standards.md` land the archive and the retrospective as separate PRs (PRs #99 and #100).

`check-initiative-history.mjs` checks titles only. It doesn't check the shape of the branch, so nothing flags a coordinator PR between steps.

Related open entries:

- Entry 0000343 covers the setup-record PRs.
- Entry 0000339 covers untitled one-commit squash subjects.
- Entry 0000332 covers id reservation on a feature branch.

Source retrospective: `plan/retrospectives/0000312-guards-history-and-test-noise-initiative-2026-11-01.md`.

## Suggested Action

The human set this rule on 2026-11-01. A delivered initiative branch holds at most N + 1 squash commits, where N is the number of steps: one squash per step, then one chore commit.

| Position | Commit | Holds |
|----------|--------|-------|
| First to Nth | One squash per step | The feature, plus admin work that aligns with that step |
| Last | One chore commit | All admin work that fits no step: the chart, deferred entries, setup records, notes, fixes, the archive, and the retrospective |

1. Admin work that aligns with a step goes in that step's PR. If the step is already running, the coordinator queues the work in `plan/.initiative-queue/` with the step named. The step session commits it on its feature branch before P4 raises the PR.
2. Admin work that fits no step lands on the initiative branch as it happens, through a `chore/` PR. Steps then run on current admin, such as the chart and the id counter.
3. At I-E Delivery, with the driver stopped, the coordinator reshapes the branch:
   1. Replay each step's own diff, in chart order, onto the base the branch was cut from.
   2. Add one chore commit whose tree equals the branch head before the reshape. The final tree stays unchanged.
   3. Run `check-initiative-history.mjs` and the full suite on the reshaped branch.
   4. Push with `git push --force-with-lease={branch}:{old head}`.
   5. Move each step tag to its new step commit, keeping the tag message.
4. Make `check-initiative-history.mjs` check the shape: one commit per charted step in chart order, then at most one chore commit. Any other commit fails CI. This tightens the check and widens nothing.

### Widening: force push to initiative branches

The human approved this widening on its own on 2026-11-01. It changes written rules, not hooks:

- `ravintio-ship/SKILL.md` says a run never force-pushes `initiative/*`.
- The I-E Delivery rules in `roadmap-standards.md` say "Do not merge or force-push to fix the history."

Suggested bounds:

- Only `--force-with-lease`, naming the expected old head.
- Only `initiative/*`, never `main`, `feat/*`, or `hotfix/*`.
- Only the coordinator, only at I-E Delivery, and only while the driver is stopped.

`merge-guard` and the other fail-closed hooks stay unchanged.

### Trade-off

A replayed step commit lacks the admin work that sat below it during the run, such as the chart. Its tree, and the tree its tag points at, then differ from the tree the step tested. The final tree is identical, and CI runs on it.

Step diffs can also conflict with admin files during the replay. Initiative 0000312 hit two cases:

- `plan/backlog/.next-id`, which every reservation changes
- step 9 adding fields to entries the coordinator filed

When a conflict touches only admin files, the replay drops those hunks from the step commit. The chore commit restores them. Any other conflict stops for the human.

## Why Deferred

The change edits the initiative skill, the ship skill, the orchestrator P4 steps, the roadmap standards, and the history script. It needs its own design and tests.
