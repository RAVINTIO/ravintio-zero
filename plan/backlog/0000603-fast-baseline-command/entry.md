---
title: "Backlog Entry: 0000603 - Fast baseline command for step runs"
summary: "The P0 baseline runs the pack suite, which takes about 2 hours and which CI does not run."
status: "open"
priority: "medium"
theme: "pipeline"
---
# Backlog Entry: 0000603 - Fast baseline command for step runs

**Source feature:** none (human request)

**Source phase:** none (human request)

**Deferral source:** human request

**Date filed:** 2026-11-26

---

## Problem

In the consumer `claude-code-launcher`, P0 runs `ravintio-zero/tests/run-tests.sh` for the baseline. It has 425 files and takes about 2 hours. CI does not run it. The step stopped the run after 55 files. The consumer's retrospective `plan/retrospectives/0000032-terminal-adapter-real-terminal-2026-11-25.md` records it, and the consumer filed it as entry 0000034.

## Suggested Action

Let `product.yml` or a repo instruction name the baseline and full-suite command. For this repo it is the CI list: `go test -race ./...`, `golangci-lint run`, `gofumpt -l src`, and `scripts/file-gates.sh .`.

## Observable condition

A step's P0 baseline and P2 full suite run the named command and end in under 5 minutes.

## Why Deferred

Found in a consumer repo during an initiative run. The fix belongs to the pack, not the consumer.
