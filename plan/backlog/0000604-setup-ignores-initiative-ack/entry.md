---
title: "Backlog Entry: 0000604 - Setup leaves plan/.initiative-ack tracked"
summary: "Consumer setup does not git-ignore plan/.initiative-ack, although the roadmap standards say it is ignored."
status: "open"
priority: "medium"
theme: "setup"
---
# Backlog Entry: 0000604 - Setup leaves plan/.initiative-ack tracked

**Source feature:** none (human request)

**Source phase:** none (human request)

**Deferral source:** human request

**Date filed:** 2026-11-22

---

## Problem

`ravintio-zero/standards/roadmap-standards.md` says `plan/.initiative-ack` is git-ignored, so a step session never commits the human's ack. In a consumer repo, nothing ignores it.

- The pack repo's own root `.gitignore` lists `plan/.initiative-ack` at line 34.
- `ravintio-zero/.gitignore`, which setup copies into a consumer, has no `initiative` line at all.
- `setup.sh` copies that file only when the consumer has no root `.gitignore` (lines 1030 to 1041). Otherwise it skips the copy and adds nothing.

The consumer `claude-code-launcher` (pack 0.114.0) shows the gap. After `I-B Activate`, `git check-ignore plan/.initiative-ack` exits 1, and the file shows as untracked. A broad `git add plan` would commit the ack.

## Suggested Action

Add `plan/.initiative-ack` to `ravintio-zero/.gitignore`. Make setup append the pack's required ignore lines to an existing root `.gitignore` when they are missing, rather than skip the file. A test can run setup against a repo with its own `.gitignore` and check `git check-ignore plan/.initiative-ack`.

## Why Deferred

Found in a consumer repo during an initiative run. The fix belongs to the pack, not the consumer.
