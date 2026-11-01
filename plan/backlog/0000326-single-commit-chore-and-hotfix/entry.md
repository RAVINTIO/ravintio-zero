---
title: "Backlog Entry: 0000326 - chore and hotfix branches reach main as one commit"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000326 - chore and hotfix branches reach main as one commit

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

`main` now accepts merge commits only. A chore branch, such as `chore/backlog-entries-2026-10-31`, often holds several small commits, because the pack asks for a commit after every artifact. A merge commit keeps every one of them on `main`.

PR #73 shows the result. Its merge commit `fda52a7` brought in separate commits such as `332f752` and `5788aa3`. Each chore then adds several untitled commits to the history of `main`.

A branch that carries an urgent fix to `main` has the same problem. Today such a branch uses the `feat/` prefix, so nothing tells it apart from a feature that belongs in an initiative.

No step squashes a branch before the human merges it into `main`. No check flags such a PR that still holds more than one commit.

## Suggested Action

- Before the agent asks the human to merge a PR into `main` from any branch other than `initiative/*`, the branch holds one commit on top of `origin/main`.
- The commit title follows `commit-standards.md` and names the PR number, such as `chore(backlog): file entries 0000280 to 0000325 (#77)`. The body lists the squashed commit titles.
- For a `chore/*` branch, the agent squashes in place and pushes with `git push --force-with-lease` to that branch. The human approved this force-push on 2026-10-31 for `chore/*` branches only.
- Name the branches that may target `main`: `initiative/*`, `chore/*`, and `hotfix/*`. A `hotfix/*` branch carries an urgent fix. Every `feat/*` branch targets an initiative branch, never `main`.
- Where the pack cuts a branch for a run outside an initiative, it uses `hotfix/` rather than `feat/`.
- For a `hotfix/*` branch, the agent never force-pushes. It builds one squashed commit on a new branch cut from `origin/main`, raises a replacement PR, and closes the old PR with a link to the new one.
- The agent never force-pushes `main` or `initiative/*`.
- The agent waits for CI to pass on the single-commit head before it asks the human to merge.
- Add a CI check on PRs into `main`. It fails when a `chore/*` or `hotfix/*` PR holds more than one commit. It also fails any PR into `main` from a branch outside `initiative/*`, `chore/*`, and `hotfix/*`.
- Document the rule in the ship skill and wherever the pack raises a PR into `main`.

## Wanted outcome

Every PR into `main` from outside an initiative reaches `main` as one titled commit under its merge commit. Tests check these conditions:

- The CI check fails a `chore/*` or `hotfix/*` PR into `main` that holds two commits.
- The CI check passes a `chore/*` or `hotfix/*` PR into `main` that holds one commit.
- The CI check fails a `feat/*` PR into `main`.
- The CI check ignores PRs from `initiative/*`, which keep their step history.
- The skill text limits `--force-with-lease` to `chore/*` branches, and names the replacement PR for every other branch.
- The skill text names the wait for CI before the merge request.

## Why Deferred

The human asked for it on 2026-10-31 while charting initiative 0000312. No step session is active.
