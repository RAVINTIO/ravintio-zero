---
title: "Postmortem: 2026-11-26 - runner temp folder inside the repo"
summary: "CI shard 1 failed because the runner put its private TMPDIR under the repo when TMPDIR was unset."
status: "closed"
---
# Postmortem: 2026-11-26 - runner temp folder inside the repo

> Path: `plan/postmortems/2026-11-26-runner-temp-folder-inside-repo.md`. Written by `ravintio-postmortem`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Trigger:** failed CI run
**Feature:** 0000583-step-temp-cleanup-after-merge
**Date:** 2026-11-26

## Summary

CI shard 1 on PR 252 failed `test-0000385-req-003-clean-clone.sh`. The runner placed its private `TMPDIR` at `{repo}/.t/` when `TMPDIR` was unset, so suites that expect a folder outside a git repository found the repo. The failure stopped the step PR until a fix landed.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-26T06:56:00Z | The runner change landed with the base path `{repo}/.t` for an unset `TMPDIR` | commit e617774b |
| 2026-11-26T07:30:00Z | The local full run passed because macOS sets `TMPDIR` | build log, Tests run lines |
| 2026-11-26T08:07:00Z | CI shard 1 failed on Linux, where `TMPDIR` is unset | PR 252 check `bash-suites shard 1` |
| 2026-11-26T08:20:00Z | The runner moved to `mktemp -d -t`, and shard 1 passed with `TMPDIR` unset | commit fba7dc60 |

First missed chance to catch it: the local full run in P2 and the clean clone in P3. Both ran on macOS, where `TMPDIR` is always set.

## 5 whys

1. CI shard 1 failed.
2. Suites that need a folder outside a git repository found the repo through `{repo}/.t`.
3. The runner chose the repo as the fallback base when `TMPDIR` was unset.
4. No local run had `TMPDIR` unset, so the fallback never ran.
5. The pack has no check that runs the suite with the CI environment, where `TMPDIR` is unset.

**Gap:** The local and clean-clone runs inherit the macOS `TMPDIR`, so no run before CI tests a branch that needs an unset `TMPDIR`.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Create the runner folder with `mktemp -d -t`, which never uses the repo | done | step 38 | `src/ravintio-zero/tests/run-tests.sh` | shard 1 run with `TMPDIR` unset | commit fba7dc60 |
| preventive | none, because a rule for an unset `TMPDIR` in `clean-clone-test.mjs` needs its own backlog entry | none | step 38 | none | none | none |
| detective | none, because CI already runs the suite on Linux and found it | none | step 38 | none | none | none |
