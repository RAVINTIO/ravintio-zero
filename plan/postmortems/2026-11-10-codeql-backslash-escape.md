---
title: "Postmortem: 2026-11-10 - CodeQL backslash escape"
summary: "A blameless record of why CodeQL found unescaped backslashes in add-step after P3, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-10 - CodeQL backslash escape

> Path: `plan/postmortems/2026-11-10-codeql-backslash-escape.md`. Written by `ravintio-postmortem`.

**Trigger:** failed CI run
**Feature:** 0000399-smoother-activation
**Date:** 2026-11-10

## Summary

The CodeQL check failed on PR 152 with four high alerts. `initiative-add-step.mjs` escaped quotes in a YAML title and left backslashes alone. The fix escapes backslashes first.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-10T01:17Z | The unit wrote the quote escape | commit 7ebcb081 |
| 2026-11-10T01:55Z | CodeQL flagged lines 115 and 116 in both pack copies | check run 129570706323 |
| 2026-11-10T02:00Z | Backslashes were escaped with `yamlQuote` | commit 4d28fd03 |

First missed chance to catch it: P3, which ran no static analysis before the PR.

## 5 whys

1. CodeQL failed the PR.
2. The title escape handled quotes and not backslashes.
3. The unit tested quotes only.
4. The unit brief did not name string escaping as a risk.
5. P3 has no local CodeQL step, so the alert showed up only in CI.

**Gap:** P3 has no local static analysis step, and unit briefs do not name escaping rules.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Escape backslashes before quotes | done | step 21 | `src/ravintio-zero/scripts/initiative-add-step.mjs` | CodeQL on PR 152 | commit 4d28fd03 |
| preventive | none, because no pack standard owns string escaping and one finding does not justify one | none | step 21 | none | none | none |
| detective | none, because CodeQL already runs on every PR | none | step 21 | none | none | none |
