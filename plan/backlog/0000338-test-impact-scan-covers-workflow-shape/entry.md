---
title: "Backlog Entry: 0000338 - test impact scan covers workflow-shape tests"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000338 - test impact scan covers workflow-shape tests

**Source feature:** 0000327-squash-before-main
**Source phase:** P2
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-01

---

## Problem

The plan skill's test impact scan lists four causes: skill count, skill-text budget, size cap, and backlog entry id. It has no cause for a new CI job or workflow step. In step 10, `test-0000169-req-006-release-tag-ci-and-ship-flow.sh` required every job outside a fixed list to carry one `if` condition. The new `squash-before-main` job failed it. The failure showed up only in the full suite, after P2. Step 7 of this initiative hit the same pattern and added its jobs to the list by hand. The source retrospective is `plan/retrospectives/0000327-squash-before-main-2026-11-01.md`.

## Suggested Action

- Add a cause to the test impact scan in `ravintio-zero/skills/ravintio-plan/SKILL.md`: the run adds or edits a job or step in a workflow file. The scan greps `ravintio-zero/tests/` for `ravintio.yml` and lists each match.
- Better, make the job-list exclusion in `test-0000169-req-006` read a marker comment on the job instead of a fixed list of names, so a new job needs no test edit.

## Wanted outcome

A run that adds a workflow job lists the workflow-shape tests in its execution plan, so P2 edits them before the full suite runs. Tests check these conditions:

- The plan skill names the workflow cause in its test impact scan.
- Adding a job that carries a marker comment does not fail `test-0000169-req-006`.

## Why Deferred

The fix changes the plan skill and a shared test. Step 10 is a CI and ship change, so the work stays out of its scope.
