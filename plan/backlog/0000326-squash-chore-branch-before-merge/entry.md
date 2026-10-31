---
title: "Backlog Entry: 0000326 - squash a chore branch to one commit before it merges"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000326 - squash a chore branch to one commit before it merges

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

`main` now accepts merge commits only. A chore branch, such as `chore/backlog-entries-2026-10-31`, often holds several small commits, because the pack asks for a commit after every artifact. A merge commit keeps every one of them on `main`.

PR #73 shows the result. Its merge commit `fda52a7` brought in separate commits such as `332f752` and `5788aa3`. Each chore then adds several untitled commits to the history of `main`.

No step squashes a chore branch before the human merges it. No check flags a chore PR that still holds more than one commit.

## Suggested Action

- Before the agent asks the human to merge a chore PR into `main`, it squashes the branch to one commit on top of `origin/main`.
- The commit title follows `commit-standards.md` and names the PR number, such as `chore(backlog): file entries 0000280 to 0000325 (#77)`. The body lists the squashed commit titles.
- The agent pushes the squashed branch with `git push --force-with-lease` to that chore branch only. It never force-pushes `main` or `initiative/*`.
- The agent waits for CI to pass on the squashed head before it asks the human to merge.
- Add a CI check on PRs into `main` from `chore/*`. It fails when the PR holds more than one commit.
- Document the rule in the ship skill and wherever the pack raises a chore PR.

## Wanted outcome

Every chore PR reaches `main` as one titled commit under its merge commit. Tests check these conditions:

- The CI check fails a `chore/*` PR into `main` that holds two commits.
- The CI check passes a `chore/*` PR into `main` that holds one commit.
- The CI check ignores PRs from `initiative/*`, which keep their step history.
- The skill text names the squash, the `--force-with-lease` push to the chore branch only, and the wait for CI.

## Why Deferred

The human asked for it on 2026-10-31 while charting initiative 0000312. No step session is active.
