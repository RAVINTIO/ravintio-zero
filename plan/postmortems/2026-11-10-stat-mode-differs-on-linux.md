---
title: "Postmortem: 2026-11-10 - stat mode differs on Linux"
summary: "A blameless record of why the new helper test failed on the Linux CI shard, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-10 - stat mode differs on Linux

> Path: `plan/postmortems/2026-11-10-stat-mode-differs-on-linux.md`. Written by `ravintio-postmortem`.

**Trigger:** failed CI run
**Feature:** 0000442-ready-file-helper
**Date:** 2026-11-10

## Summary

The test `test-0000442-req-001-ready-helper.sh` read the file mode with BSD `stat -f %Lp` first. On Linux that flag prints filesystem data and exits 0, so the check failed on bash-suites shard 4. The test now tries GNU `stat -c %a` first.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-10T16:40Z | The unit wrote the test with `stat -f %Lp` first, and it passed on macOS | commit 21871eac |
| 2026-11-10T17:35Z | The clean clone and the working-tree run passed on macOS only | `plan/current/acceptance-evidence.md` |
| 2026-11-10T17:38Z | Shard 4 failed the `AC-1: mode 600` check | CI run 42866680708, job 130006771048 |
| 2026-11-10T17:58Z | The test was changed to try GNU `stat` first | commit 7e91bacc |

First missed chance to catch it: P2, when the unit wrote the test. Nothing in the unit asked for a check on the CI operating systems.

## 5 whys

1. The `AC-1: mode 600` check failed on the Linux shard.
2. `stat -f %Lp` succeeded on Linux with filesystem output, so the fallback to `stat -c %a` never ran.
3. The unit ran the test only on macOS, where the BSD form is right.
4. The local run records an `OS gap` line but runs no check on the CI systems.
5. No standard tells a test author which `stat` form is portable.

**Gap:** The testing standards name no portable form for reading a file mode, and the local run cannot show a Linux-only failure.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Try GNU `stat -c %a` before BSD `stat -f %Lp` | done | step 25 | `src/ravintio-zero/tests/test-0000442-req-001-ready-helper.sh` | CI bash-suites shards | commit 7e91bacc |
| preventive | none, because the test is the only use of a file mode and it now holds the portable order | none | step 25 | none | none | none |
| detective | none, because the Linux CI shard caught this failure before merge | none | step 25 | none | none | none |
