---
title: "Retrospective: 2026-11-01 - initiative history checks"
summary: "A blameless review of step 7 of initiative 0000312, and the changes it files."
status: "open"
---
# Retrospective: 2026-11-01 - initiative history checks

> Path: `plan/retrospectives/0000319-initiative-history-checks-2026-11-01.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000319-initiative-history-checks
**Date:** 2026-11-01

## Summary

The step added a first-parent title check for initiative branches and a squash check for `main`. Version 0.45.0 shipped with no self-correction cycles.

## What helped

- Three parallel units finished P2 in 22 minutes with no rework (`build-log.md` P2 block).
- Throwaway-repo runs showed each script exit code for six cases (`verification-report.md`).

## What slowed the work

- The full suite passed the 120 second foreground limit and moved to the background (P3 run).
- The P3 end time came from an estimate, and the build-log check then failed at ship (`build-log-check.mjs` output: `P4: End is before Start`).

## Keep

- Run script criteria against a throwaway repo, not the working tree (`verification-report.md`).

## Change

- Take every phase timestamp from the clock (`ravintio-validate-and-accept/SKILL.md`, `ravintio-ship/SKILL.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Phase timestamps from `date -u` | pack maintainers | `ravintio-zero/skills/` | `build-log-check.mjs` passes at ship | `plan/backlog/0000335-p3-block-timestamps-from-clock/entry.md` |
