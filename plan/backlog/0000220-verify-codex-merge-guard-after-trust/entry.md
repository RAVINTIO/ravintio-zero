---
title: "Backlog Entry: 0000220 - verify codex merge-guard after trust"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000220 - verify codex merge-guard after trust

**Source feature:** 0000217-verify-codex-setup
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-27

---

## Problem

Step 14 showed that Codex 0.163.0 skips the project `merge-guard` hook until a person trusts it with `/hooks`. The block after trust is unverified, because trust needs a human and the trust-bypass flag was denied. Two harness facts also cost time:

- Codex runs commands in `zsh -lc`, which resets `PATH`. A stub `gh` needs a `ZDOTDIR` `.zprofile` to come first.
- `setup.sh` takes its project root from its own location, so it must run from a copy of the pack inside the target repo.

## Suggested Action

A person trusts the hook with `/hooks` in a Codex session in a fresh repo set up with `setup.sh codex`. They then ask Codex to run a merge command with a stub `gh` first on `PATH` and record the exit code and the stub log. Add the two harness facts to `getting-started.md`.

## Wanted outcome

The recorded run shows Codex blocking the merge command with exit 2 and an empty stub log, or it names the contract difference that stops the block.

## Why Deferred

The check needs an interactive trust step that only a human can take. Step 14 was a charted chore with no human present.
