---
title: "Postmortem: 2026-11-09 - tests assumed the pack sits at the repo root"
summary: "A blameless record of why 43 suites failed on the first run from src/ravintio-zero/, and the actions that close the gap."
status: "open"
---
# Postmortem: 2026-11-09 - tests assumed the pack sits at the repo root

> Path: `plan/postmortems/2026-11-09-tests-assumed-pack-at-repo-root.md`. Written by `ravintio-postmortem`.
> Blameless: a cause names a gap in a process, check, standard, or tool.

**Trigger:** P2 self-correction
**Feature:** 0000397-pack-source-in-src
**Date:** 2026-11-09

## Summary

The first full suite run from `src/ravintio-zero/tests/` failed 43 suites. Four fix tracks changed the repo-root lookup in about 40 test files.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-09T21:42:49Z | The pure move commit landed | commit `b419da39` |
| 2026-11-09T21:42:58Z | The copy commit made `ravintio-zero/` a plain copy | commit `9b9a782d` |
| 2026-11-09T22:10:57Z | The first full run from the source finished with 43 failed suites | `Failed suites:` list in `/tmp/s20b.log` |
| 2026-11-09T22:13:23Z | Four fix tracks began to commit repo-root fixes | commit `0ed4f168` |
| 2026-11-09T23:12:55Z | A run from the installed folder showed three more whole-repo scans, and a fix landed | commit `e52b60ec` |

First missed chance to catch it: P1 Plan. The test impact scan has no cause for a folder move, so `execution-plan.md` listed no test for the root lookup.

## 5 whys

1. The suite failed from `src/ravintio-zero/tests/` because many tests found the repo root one folder above the pack.
2. The tests used `$ZERO_DIR/..` and `$SCRIPT_DIR/../..`, which equal the repo root only when the pack sits at the root.
3. No standard says how a test finds the repo root, so each author chose a path shortcut.
4. The plan scan lists nine causes for a test change, and none covers a moved folder.
5. No check runs the suite from a new layout before P2 starts.

**Gap:** the plan skill's test impact scan and the testing standard do not cover a folder move or a repo-root lookup.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Use `git rev-parse --show-toplevel` for the repo root in the failing tests | done | step 20 | `src/ravintio-zero/tests/` | full suite from both folders | commit e52b60ec |
| preventive | Add a `Path move` cause to the test impact scan | filed | pack maintainers | `src/ravintio-zero/skills/ravintio-plan/SKILL.md` | review of the scan list | backlog 0000419 |
| detective | Run the suite from the new layout before P2 starts | filed | pack maintainers | `src/ravintio-zero/skills/ravintio-plan/SKILL.md` | review of the scan list | backlog 0000419 |
