---
title: "Backlog Entry: 0000345 - fold coordinator admin into the next step PR"
summary: "A human-requested change, filed for pickup at a future discovery run."
status: "open"
priority: "high"
theme: "initiative-history"
---
# Backlog Entry: 0000345 - fold coordinator admin into the next step PR

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

The human set this rule on 2026-11-01. An initiative branch holds at most N + 2 squash commits, where N is the number of steps:

| Position | Commit | Holds | Needed |
|----------|--------|-------|--------|
| First | Opening chore | Planning work, the chart, and backlog entries deferred at chart time | Optional |
| Middle | One squash per step | The feature, plus admin work that aligns with that step | One per step |
| Last | Closing chore | Admin work that fits no step, the archive, and the retrospective | Optional |

1. Admin work that aligns with a step goes in that step's PR. If the coordinator finds it while the step runs, it queues the work in `plan/.initiative-queue/` with the step named. The step session commits it on its feature branch before P4 raises the PR.
2. Admin work that fits no step waits in the queue until the last step merges. It then lands in the closing chore PR. The coordinator raises no PR between steps.
3. A setup record can't join the PR of the step that caused it, because setup reruns after that step merges. It waits for the closing chore. Entry 0000343 removes the record once setup stops writing a tracked timestamp.
4. Make `check-initiative-history.mjs` check the shape. It allows an optional opening chore, then one commit per charted step in chart order, then an optional closing chore. Any other commit fails CI. This tightens the check and widens nothing.

## Why Deferred

The change edits the initiative skill, the orchestrator P4 steps, the roadmap standards, and the history script. It needs its own design and tests.
