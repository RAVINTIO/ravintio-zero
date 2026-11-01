---
title: "Backlog Entry: 0000345 - the coordinator lands nothing between steps"
summary: "A human-requested change, filed for pickup at a future discovery run."
status: "open"
priority: "high"
theme: "initiative-history"
---
# Backlog Entry: 0000345 - the coordinator lands nothing between steps

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

1. Keep queued entries in `plan/.initiative-queue/` until I-E Delivery, and land them in the closing PR.
2. Keep supervision notes in an ignored path until I-E Delivery.
3. Land the archive, the retrospective, and the queued entries in one closing PR.
4. Make `check-initiative-history.mjs` check the shape: one activation commit, then one commit per charted step in chart order, then one closing commit. Any other commit fails CI. This tightens the check and widens nothing.

## Why Deferred

The change edits the initiative skill, the roadmap standards, and the history script. It needs its own design and tests.
