---
title: "Backlog Entry: 0000325 - lint the GitHub Actions workflows in CI"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000325 - lint the GitHub Actions workflows in CI

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

Nothing checks `.github/workflows/ravintio.yml` before it runs. A mistake there shows up only when a job fails or misbehaves on GitHub. A security weakness may never show up at all.

The workflow already sets `permissions: contents: read` at the top. Two jobs still use `actions/checkout@v4` rather than a pinned SHA (lines 18 and 53). Entry 0000323 covers those two pins. No check stops a new unpinned action or a new risky pattern from landing later.

CodeQL default setup scans the `actions` language, but its queries cover fewer workflow problems than a dedicated linter.

## Suggested Action

Add one CI job that runs two free linters on `.github/workflows/`:

- `actionlint` checks syntax, expressions, and job wiring. It also runs `shellcheck` on `run:` steps.
- `zizmor` checks security. It flags unpinned actions, template injection, and broad token permissions.

Fail the job on any finding. Fix or record each existing finding first, so the job starts green. Consider making the job a required check in the `Protect Main Branch` ruleset.

## Why Deferred

The human filed it on request. It adds a CI job to the pack, so it needs its own run with tests.
