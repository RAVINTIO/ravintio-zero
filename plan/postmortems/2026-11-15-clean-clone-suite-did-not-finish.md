---
title: "Postmortem: 2026-11-15 - Clean-clone suite did not finish under load"
summary: "A blameless record of why the P3 full suite stopped at the time limit, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-15 - Clean-clone suite did not finish under load

> Path: `plan/postmortems/2026-11-15-clean-clone-suite-did-not-finish.md`. Written by `ravintio-postmortem`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Trigger:** Blocked stop
**Feature:** 0000562-test-impact-scan-lists-the-mirrored-pack-tree
**Date:** 2026-11-15

## Summary

P3 could not finish the full suite in a clean clone. Two runs hit the background limit at load average 26. The resume ran the suite again at load 2 to 7. It finished with five failed suites outside the changed files.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-15T04:25:21Z | Two clean-clone runs stop at the limit. P3 logs `Blocked:` and `Complete: P3`. | build-log P3 block |
| 2026-11-15T12:30Z | Resume finds the open stop and the load at 1.7. | `resume-detect.mjs` output |
| 2026-11-15T12:52Z | The rerun ends with 5 failed suites. | `/tmp/step18-full.log` |
| 2026-11-15T12:53Z | Two suites pass in the worktree. Two fail on a path layout the step did not touch. | `acceptance-evidence.md` |

First missed chance to catch it: P3 Validate. The phase logged `Complete: P3` after a `Blocked:` line, so the stop never reached the human.

## 5 whys

1. The full suite did not finish in P3.
2. Four steps ran their suites at once and the load reached 26.
3. The suite takes about 40 minutes even under light load and has no resume point.
4. The P3 skill gives no rule for a suite that cannot finish, so the step wrote `Blocked:` and carried on.
5. The pack has no exception row or fallback for a full suite that exceeds the time limit.

**Gap:** The validate-and-accept skill has no rule for a full suite that cannot finish in the time limit.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Rerun the suite at low load and record the five failures | done | step 18 | `plan/current/acceptance-evidence.md` | The evidence file names each failed suite | commit on this branch |
| preventive | none, because the pack owner has not chosen a fallback and a guess would widen a gate | none | none | none | none | none |
| detective | none, because `build-log-check.mjs` already reports the `Blocked:` line that has no `Resolved:` line | none | none | none | none | none |
