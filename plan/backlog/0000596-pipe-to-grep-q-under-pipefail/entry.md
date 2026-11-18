---
title: "Backlog Entry: 0000596 - Pipe to grep -q under pipefail"
summary: "58 suites pipe to grep -q under pipefail. The pattern made the old-name guard fail at random in 0000561."
status: "open"
priority: "low"
theme: "tests"
---
# Backlog Entry: 0000596 - Pipe to grep -q under pipefail

**Source feature:** 0000561-old-name-guard-fails-in-full-suite
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-18

---

## Problem

`grep -q` exits at its first match. Under `set -o pipefail`, the writer in `printf ... | grep -q ...` can then end with a failed status, and the pipeline reports failure. Step 17 found this in the old-name guard, where it made an allowlisted file a hit at random. A search of `ravintio-zero/tests/*.sh` finds 58 suites that set `pipefail` and also hold a `| grep -q` line.

## Suggested Action

Add a style test that flags `| grep -q` in a suite that sets `pipefail`, with a list of reviewed exceptions. Fix the real flakes it finds by matching in Bash or by reading a here-document.

## Wanted outcome

A style test fails on a new `| grep -q` under `pipefail`. The change fixes each existing hit or lists it as reviewed with a reason. A suite that hits the pattern gives the same result in a solo run and a full-suite run.

## Why Deferred

Step 17 fixes the old-name guard only. The other suites have shown no failure, and a bulk edit of 58 suites is out of scope.

## Source retrospective

`plan/retrospectives/0000561-old-name-guard-fails-in-full-suite-2026-11-18.md`
