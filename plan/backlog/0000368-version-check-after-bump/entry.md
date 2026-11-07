---
title: "Backlog Entry: 0000368 - check every version file after the P4 bump"
summary: "A P4 bump that misses a version file passes locally and fails CI."
status: "open"
priority: "medium"
theme: "ship"
---
# Backlog Entry: 0000368 - check every version file after the P4 bump

**Source feature:** 0000355-codeql-and-branch-cleanup
**Source phase:** P4
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-07

---

## Problem

Step 5 of initiative 0000349 bumped `docs/about.md` and `product.yml` to `0.53.0` and missed `ravintio-zero/component.yml`. The full suite had run in P3, before the bump, so nothing caught it locally. The `bash-suites` job on PR #115 failed, and the step fixed it in a second commit.

## Suggested Action

1. After the bump and before the push, run the version consistency test, or a script that reads every version file and compares them.
2. Stop the ship step when any file differs.
3. List the version files in one place that the bump and the check both read.

## Why Deferred

The coordinator found it while step 5 ran. No step in the initiative covers ship.
