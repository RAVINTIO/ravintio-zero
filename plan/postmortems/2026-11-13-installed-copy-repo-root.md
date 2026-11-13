---
title: "Postmortem: 2026-11-13 - New test failed in the installed copy"
summary: "A blameless record of why a new test passed in src/ and failed in the clean clone, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-13 - New test failed in the installed copy

> Path: `plan/postmortems/2026-11-13-installed-copy-repo-root.md`. Written by `ravintio-postmortem`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Trigger:** P2 self-correction
**Feature:** 0000534-step-sessions-receive-clock
**Date:** 2026-11-13

## Summary

The new test `test-0000534-req-001-003-step-clock.sh` found the repo root three folders above the script. That path is right in `src/ravintio-zero/tests/` and wrong in the installed `ravintio-zero/tests/`. The full suite in a clean clone failed one suite. The fix landed before P3.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-13T04:25:27Z | The test is RED and then GREEN when run from `src/ravintio-zero/tests/`. | Build log, P2 block |
| 2026-11-13T04:26:30Z | The installed copy is synced and committed. | Commit 0c2e6b21 |
| 2026-11-13T04:41:00Z | The clean-clone run prints one failure for the new suite. | `/tmp/step60-p2-suite.out`, build log `Tests run: full suite` line |
| 2026-11-13T04:47:00Z | The test finds the root from both folders and passes in both. | Commit 1ccbc4a8 |

First missed chance to catch it: the agent ran the new test only from `src/` before the commit. A run of the installed copy of the test would have caught it.

## 5 whys

1. The new test failed in the clean clone.
2. It read `docs/decisions-index.md` through a path that exists only from `src/ravintio-zero/tests/`.
3. The agent ran the test from `src/` only, and the affected-test run does not run the installed copy.
4. The tests run from two folders, and no rule or helper names the repo root for both.
5. The test helpers hold no shared repo-root function, so each test works out its own path.

**Gap:** `helpers/assert.sh` offers no repo-root helper that works from `src/` and from the installed copy.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | The test finds the repo root from both folders. | done | the step | `src/ravintio-zero/tests/test-0000534-req-001-003-step-clock.sh` | The test passes in both folders. | 1ccbc4a8 |
| preventive | none, because the shared helper is a wider change than this step and the case is rare. | none | the step | none | none | none |
| detective | none, because the clean-clone full suite already caught it before P3. | none | the step | none | none | none |
