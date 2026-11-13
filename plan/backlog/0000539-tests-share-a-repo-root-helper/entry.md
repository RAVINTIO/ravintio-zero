---
title: "Backlog Entry: 0000539 - Tests share a repo root helper"
summary: "Each test works out the repo root from its own path, and a test that passes from src/ can fail in the installed copy."
status: "open"
priority: "low"
theme: "tests"
---
# Backlog Entry: 0000539 - Tests share a repo root helper

**Source feature:** 0000534-step-sessions-receive-clock

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-13

---

## Problem

The tests run from two folders, `src/ravintio-zero/tests/` and the installed `ravintio-zero/tests/`. Each test works out the repo root from `$SCRIPT_DIR` on its own. The new test `test-0000534-req-001-003-step-clock.sh` used the source depth and failed in the clean clone. The postmortem `plan/postmortems/2026-11-13-installed-copy-repo-root.md` records the chain.

## Suggested Action

Add a `repo_root` function to `src/ravintio-zero/tests/helpers/assert.sh` that works from both folders. Name it in the test writing standard, so new tests call it.

## Why Deferred

The helper touches the shared assertion file that every suite sources. It needs its own step and its own full suite run.
