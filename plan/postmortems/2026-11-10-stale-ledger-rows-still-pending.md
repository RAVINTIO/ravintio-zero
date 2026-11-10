---
title: "Postmortem: 2026-11-10 - stale ledger rows still pending"
summary: "A blameless record of why the first Detect rule left migrations 0004 and 0005 pending, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-10 - stale ledger rows still pending

> Path: `plan/postmortems/2026-11-10-stale-ledger-rows-still-pending.md`. Written by `ravintio-postmortem`.

**Trigger:** P2 self-correction
**Feature:** 0000399-smoother-activation
**Date:** 2026-11-10

## Summary

The first Detect rule applied only to a migration with no ledger row. Migrations 0004 and 0005 have `not applicable` rows from an older pack version, so they still printed as pending. The rule now applies to any row.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-10T01:15Z | The unit added the rule for a migration with no ledger row | commit df6bbc5a |
| 2026-11-10T01:33Z | The installed copy still printed 0004 and 0005 | the resume-detect run in P3 |
| 2026-11-10T01:36Z | The rule was widened to every row, with a stale-row test | commit 26a5d839 |

First missed chance to catch it: the unit test, which planted fixtures with no ledger row and never planted a stale row.

## 5 whys

1. Migrations 0004 and 0005 still printed after the change.
2. The rule skipped them only when no ledger row existed.
3. The requirement named "a migration with no ledger row" and the brief never named the real stale rows.
4. The unit tested planted fixtures and not the real migrations with the real ledger.
5. No step in the unit checks the wanted outcome against the repo's own state.

**Gap:** The unit brief and tests do not require a run against the repo's real inputs.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Apply the Detect rule to any ledger row | done | step 21 | `src/ravintio-zero/scripts/resume-detect.mjs` | the stale-row test | commit 26a5d839 |
| preventive | Add a stale-row case to the test | done | step 21 | `src/ravintio-zero/tests/test-0000399-req-006-detect-applies.sh` | the suite | commit 26a5d839 |
| detective | none, because the stale-row test now fails if the rule narrows again | none | step 21 | none | none | none |
