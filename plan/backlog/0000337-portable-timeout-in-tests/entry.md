---
title: "Backlog Entry: 0000337 - tests use one portable timeout helper"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "low"
theme: "tests"
---
# Backlog Entry: 0000337 - tests use one portable timeout helper

**Source feature:** 0000321-backlog-triage
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-01
**Source retrospective:** `plan/retrospectives/0000321-backlog-triage-2026-11-01.md`

---

## Problem

A test that needs a time limit has no shared helper. The macOS shell has no `timeout` command, so a new test that called it exited 127 (`test-0000321-req-005-default-migration.sh`, fixed with `perl -e 'alarm 20; exec @ARGV'`). `test-0000243-req-003-004-hook-injection.sh` solves the same need its own way.

## Suggested Action

Add one helper to `ravintio-zero/tests/helpers/` that runs a command with a limit on macOS, Linux, and Git Bash. Move the two tests onto it. Name the helper in `testing-standards.md`.

## Wanted outcome

A test author writes one line to cap a command, and the test passes on every runner. A test checks that the helper stops a command that outlives its limit and passes one that does not.

## Why Deferred

The run only needed a limit in one test. A shared helper touches other suites and needs its own design.
