---
title: "Postmortem: 2026-11-11 - Installed copy check used the wrong root"
summary: "A new pin suite computed the repo root from its own folder, which is wrong for the installed copy of the suite."
status: "closed"
---
# Postmortem: 2026-11-11 - Installed copy check used the wrong root

> Path: `plan/postmortems/2026-11-11-installed-copy-check-used-wrong-root.md`. Written by `ravintio-postmortem`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Trigger:** P2 self-correction
**Feature:** 0000519-ship-removal-needs-human-approval
**Date:** 2026-11-11

## Summary

The new suite `test-0000519-req-001-ship-removal-command.sh` passed from `src/ravintio-zero/tests/` and failed from `ravintio-zero/tests/` in the full run. A later fix made it pass in both places. No defect reached the PR.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-11T08:44:24Z | The suite ran RED, then GREEN, from the source folder only | build log P2 block |
| 2026-11-11T09:46:32Z | The full run reported the suite failing, with exit 2 from the sync check | `/tmp/step58-full.txt` lines 19 to 29 |
| 2026-11-11T09:46:32Z | The suite ran from the installed folder and failed | build log `Rework:` line |
| 2026-11-11T09:46:50Z | The root came from `git rev-parse --show-toplevel`, and the suite passed in both folders | commit e39c6330 |

First missed chance to catch it: the RED and GREEN runs used the source copy only. No run used the installed copy of the suite until the full suite.

## 5 whys

1. The suite failed in the full run because `ROOT` pointed one level above the repo from the installed folder.
2. `ROOT` came from `$ZERO_DIR/../..`, which only holds for `src/ravintio-zero/`.
3. The suite took its folder depth from the source layout alone.
4. The affected-test run in P2 runs the source copy, so it never exercised the installed layout.
5. No pack standard names the two suite layouts. No check runs a new suite from the installed copy before the full run.

**Gap:** the testing standard does not name the two layouts, and the P2 affected-test run does not run the installed copy of a new suite.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Take the root from `git rev-parse --show-toplevel` | done | ravintio-zero | `src/ravintio-zero/tests/test-0000519-req-001-ship-removal-command.sh` | The suite passes from both folders | e39c6330 |
| preventive | none, because the full suite already runs the installed copy and caught it before the PR | none | ravintio-zero | not applicable | not applicable | not applicable |
| detective | none, because the full suite is the detector and it worked | none | ravintio-zero | not applicable | not applicable | not applicable |
