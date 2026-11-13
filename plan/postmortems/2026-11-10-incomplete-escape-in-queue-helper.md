---
title: "Postmortem: 2026-11-10 - incomplete escape in the queue helper"
summary: "A blameless record of why CodeQL flagged an escape that missed the backslash, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-10 - incomplete escape in the queue helper

> Path: `plan/postmortems/2026-11-10-incomplete-escape-in-queue-helper.md`. Written by `ravintio-postmortem`.

**Trigger:** P2 self-correction
**Feature:** 0000444-step-reads-its-queue-items
**Date:** 2026-11-10

## Summary

CodeQL reported two high alerts on PR 171. The helper `initiative-queue.mjs` built a pattern from item data and escaped the dot but not the backslash. A name that matches `NAME` holds no backslash, so no exploit existed. The fix escapes every metacharacter.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-10T21:51Z | The helper passed its suite with a single-character escape | `plan/current/build-log.md`, GREEN U-001 |
| 2026-11-10T22:07Z | The P3 security review rated the pattern low and wrote that the name matches `NAME` | `plan/current/security-report.md` |
| 2026-11-10T22:09Z | CodeQL failed with "does not escape backslash characters", line 159 | PR 171 check run 130164259632 |
| 2026-11-10T22:10Z | The step replaced the escape with `escapeRe` and CI passed | commit df9f1ff9 |

First missed chance to catch it: P2, when the unit wrote the escape. The P3 security review named the same case in its own checklist and still passed it.

## 5 whys

1. CodeQL flagged the escape on the PR.
2. The escape replaced only the dot in a name, so a backslash stayed unescaped.
3. The unit relied on `NAME` to exclude a backslash and wrote a narrow escape.
4. The P3 review accepted that reliance because it reads the code by eye.
5. No local check runs the static analysis that CI runs, so the finding came after the PR.

**Gap:** CodeQL runs only on the PR, and the local P3 review has no mechanical check for a partial escape.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Escape every regular expression metacharacter with `escapeRe` | done | step session | `src/ravintio-zero/scripts/initiative-queue.mjs` | CodeQL and the suite `test-0000444-req-001-003-queue-items.sh` | df9f1ff9 |
| preventive | none, because the P3 skill already names an escape that misses a backslash, and the review missed it | none | none | none | none | none |
| detective | none, because CodeQL on the PR found the alert before the merge, so the existing check worked | none | none | none | none | none |
