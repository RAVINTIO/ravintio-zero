---
title: "Postmortem: 2026-11-09 - a test diffed against HEAD"
summary: "A blameless record of why a test that diffs against HEAD passed with no check, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-09 - a test diffed against HEAD

> Path: `plan/postmortems/2026-11-09-test-diffed-against-head.md`. Written by `ravintio-postmortem`.

**Trigger:** P2 self-correction
**Feature:** 0000391-standards-archetypes
**Date:** 2026-11-09

## Summary

Two checks in `test-0000391-req-008-standard-text.sh` diffed a file against `HEAD`. After the unit committed its work, both passed with no change to test. The orchestrator replaced them with absolute checks.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-09T18:50Z | The unit committed the test with two `git diff HEAD` checks | commit 0ff579da |
| 2026-11-09T18:51Z | The unit report said the checks report 0 added lines | the U7 hand-back |
| 2026-11-09T18:53Z | The checks were replaced with size and content checks | commits c221acec and c33c9d8b |

First missed chance to catch it: the unit report, which already said the check was empty.

## 5 whys

1. Two checks passed without testing anything.
2. They compared the working tree with `HEAD`, which matches after a commit.
3. The unit wanted to bound the lines it added and had no fixed base.
4. The testing standard says nothing about moving refs.
5. No style check flags a diff against `HEAD`.

**Gap:** The testing standard and the repo style checks do not name a diff against a moving ref.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Replace the two checks with absolute checks | done | step 15 | `ravintio-zero/tests/test-0000391-req-008-standard-text.sh` | the suite | commits c221acec and c33c9d8b |
| preventive | Add a rule against diffs with a moving ref to the testing standard | filed | pack maintainers | `ravintio-zero/standards/testing-standards.md` | review | 0000416 |
| detective | Add a style check that greps suites for a diff against `HEAD` | filed | pack maintainers | `ravintio-zero/tests/` | a test that plants one | 0000416 |
