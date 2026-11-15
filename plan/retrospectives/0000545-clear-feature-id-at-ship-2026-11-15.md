---
title: "Retrospective: 2026-11-15 - Ship leaves plan/.feature-id behind"
summary: "A blameless review of step 1 of initiative 0000544, and the change it files."
status: "open"
---
# Retrospective: 2026-11-15 - Ship leaves plan/.feature-id behind

**Mode:** run
**Subject:** 0000545-clear-feature-id-at-ship
**Date:** 2026-11-15

## Summary

Ship Step 8 now deletes `plan/.feature-id`, and the queue resolver handles a conflict on it. P1 and P2 took 11 minutes. P3 spanned 1161 minutes because the session paused before the full suite finished.

## What helped

- Two requirement suites went RED then GREEN before the removal (`plan/_archive/0000545-clear-feature-id-at-ship-2026-11-14/build-log.md`, P2 block).
- The clean-clone run separated environment failures from change failures (`plan/_archive/0000545-clear-feature-id-at-ship-2026-11-14/acceptance-evidence.md`).

## What slowed the work

- The first full-suite run reached the 10-minute foreground limit and stopped. The rerun with a longer limit passed (`build-log.md`, P3 block).
- The base merge collided on ADR 0344. Another step took the same number, and `plan/.feature-id`, the backlog index, and two living docs also conflicted (commit "0000545: Merge the initiative branch").
- The build log lacked P0 and P3 end times and a P4 block. `build-log-check.mjs` found 11 findings at ship.
- Three clean-clone suite failures needed a manual check because the baseline had no record of them (`plan/backlog/0000585-clean-clone-suite-path-gaps/entry.md`).

## Keep

- The clean-clone run in P3, because it exposes path assumptions in suites (`acceptance-evidence.md`).

## Change

- Fix the three suites that fail in a clean clone, so the baseline check reports only real regressions (`plan/backlog/0000585-clean-clone-suite-path-gaps/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Make three suites pass or skip with a reason in a clean clone | pack maintainers | `ravintio-zero/tests/` | `clean-clone-test.mjs` with no `new:` suite | `plan/backlog/0000585-clean-clone-suite-path-gaps/entry.md`, from this retrospective |
