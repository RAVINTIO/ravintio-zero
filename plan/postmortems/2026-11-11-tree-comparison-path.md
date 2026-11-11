---
title: "Postmortem: 2026-11-11 - Tree comparison path"
summary: "A blameless record of why a new test passed in the source tree and failed in the clean clone, and the actions that close the gap."
status: "open"
---
# Postmortem: 2026-11-11 - Tree comparison path

> Path: `plan/postmortems/2026-11-11-tree-comparison-path.md`. Written by `ravintio-postmortem`.

**Trigger:** P2 self-correction
**Feature:** 0000493-driver-starts-after-restart
**Date:** 2026-11-11

## Summary

The text suite compared the two pack trees with a path that holds only from `src/ravintio-zero/tests/`. The clean-clone full suite also runs the suite from `ravintio-zero/tests/`, and two checks failed there. A fix landed before ship.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-11T20:23:00Z | The U-2 suite passed 10 of 10 from `src/ravintio-zero/tests/` | the P2 block of the build log |
| 2026-11-11T21:10:00Z | The clean-clone full suite failed REQ-004 AC-3 twice | full suite output, `test-0000493-req-004-handoff-text.sh` |
| 2026-11-11T21:10:25Z | The suite took the repo top from git and passed from both trees | commit 7f98e585 |

First missed chance to catch it: U-2 verification. The unit ran its suite from one tree only.

## 5 whys

1. REQ-004 AC-3 failed in the clean clone.
2. The suite built the path of the other tree with `../../../ravintio-zero`, which only holds from `src/`.
3. The unit ran its suite from `src/ravintio-zero/tests/` and never from `ravintio-zero/tests/`.
4. The brief for the unit named no rule that a new suite must pass from both trees.
5. The pack keeps two copies of its tests, and no standard or helper says how a suite finds the other tree.

**Gap:** No standard or test helper tells a suite how to find the other tree, and no step runs a new suite from both trees.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Take the repo top from git and compare the two trees from there | done | feature 0000493 | `src/ravintio-zero/tests/test-0000493-req-004-handoff-text.sh` | the text suite passes from both trees | 7f98e585 |
| preventive | none, because the two-tree layout is temporary and the root copy goes away when the pack source moves fully to `src/` | none | not applicable | not applicable | not applicable | not applicable |
| detective | The clean-clone full suite found the failure before ship | done | pack maintainers | `ravintio-zero/scripts/clean-clone-test.mjs` | the full suite in P3 | 7f98e585 |
