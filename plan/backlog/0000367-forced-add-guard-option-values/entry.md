---
title: "Backlog Entry: 0000367 - the forced-add guard misreads git option values and brace groups"
summary: "A forced add passes the guard when a git option value comes before add, or when a brace group hides the flag."
status: "open"
priority: "high"
theme: "guards"
---
# Backlog Entry: 0000367 - the forced-add guard misreads git option values and brace groups

**Source feature:** 0000357-guard-gaps-closed
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-07

---

## Problem

`block-forced-add.mjs` passes two forms that force an ignored file into the index:

- `git --git-dir .git add $F` with `F=-f`. The function `subcommandOf` skips a value only after `-C` and `-c`. It reads `.git` as the subcommand, so the variable check passes the segment. The same applies to `--work-tree` and `--namespace`.
- `git add {-f,x}`. Bash expands the brace group to `git add -f x`. The guard splits on braces, so `-f` lands in a segment without `git`.

The first form passed after commit `8bd4d7e` narrowed the variable check. Commit `45d2fd1` blocked it. The guard on `main` before initiative 0000349 blocked neither form. The CI check on `git ls-files -ci --exclude-standard` still catches a forced add in a PR.

## Suggested Action

1. Block a segment that holds `$` when any option before the subcommand is one the guard doesn't know, or skip the value of each git option that takes one.
2. Block an add or stage segment that holds a brace group.
3. Add a test case for each form, and for `--git-dir`, `--work-tree`, and `--namespace` with a literal and a variable value.

## Why Deferred

The coordinator found it after step 6 merged. Step 7 has a different theme.
