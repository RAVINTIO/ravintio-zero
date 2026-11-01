---
title: "Backlog Entry: 0000324 - the brand guard runs before a push, not only in CI"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000324 - the brand guard runs before a push, not only in CI

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

On 2026-10-31, the `bash-suites` job failed on PR #77 (run `41204993970`). The cause was one line in `plan/backlog/0000283-update-command-and-doctor/entry.md`. It used the old product name, and `ravintio-zero/tests/test-0000160-req-006-brand-guard.sh` flagged it.

No local hook runs that test. `ravintio-zero/hooks/pre-commit` checks only for `src/` changes without docs. `ravintio-zero/hooks/pre-push` doesn't call the brand guard either. The agent learned of the failure about five minutes after the push, when the full suite finished in CI.

Backlog entries and other plan files are where the old name most often returns. Agents copy text from older repos into them, as happened in entry 0000283.

## Suggested Action

Run the brand guard's line and path checks from `pre-push`, or from `pre-commit` on staged files only. Exit non-zero on a hit and print the file and line number. Reuse the test's allowlist so the local check and CI can't disagree.

## Why Deferred

The human filed it on request. It changes a hook in the pack, so it needs its own run with tests.
