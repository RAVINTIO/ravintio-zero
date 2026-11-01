---
title: "Backlog Entry: 0000356 - CI deletes a PR's head branch once it merges"
summary: "A human-requested change, filed for pickup at a future discovery run."
status: "open"
priority: "high"
theme: "initiative-history"
---
# Backlog Entry: 0000356 - CI deletes a PR's head branch once it merges

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-11-01

---

## Problem

On 2026-11-01, `origin` held seven merged head branches:

- Six came from coordinator squashes into the initiative 0000312 branch, which used no `--delete-branch`.
- One came from PR #77 into `main`, which the human merged.

Entry 0000323 asks the developer to turn on the GitHub repo setting **Automatically delete head branches**. That pushes the fix onto every developer who installs the pack. The human ruled on 2026-11-01 that the pack solves it itself.

## Suggested Action

1. Add a workflow job that the pack ships, and run it in this repo too. It runs when a pull request into `main` or `initiative/**` closes as merged, and deletes the head branch with the workflow token.
2. Give the job `contents: write` only. Skip a head branch from a fork, and never delete `main` or `master`. An `initiative/*` head is deleted when its PR into `main` merges, because the initiative is then delivered.
3. If the branch is already gone, as after `--delete-branch`, the job exits 0.
4. Drop the **Automatically delete head branches** item from entry 0000323.

Tests could check that the template holds the job, its permission, and the protected-branch skip.

## Why Deferred

The change adds a CI job with write access, so it needs its own design and security review.
