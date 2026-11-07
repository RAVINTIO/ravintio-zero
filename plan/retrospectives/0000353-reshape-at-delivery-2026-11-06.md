---
title: "Retrospective: 2026-11-06 - reshape at delivery"
summary: "A blameless review of step 3 of initiative 0000349. It files no new change."
status: "open"
---
# Retrospective: 2026-11-06 - reshape at delivery

**Mode:** run
**Subject:** 0000353-reshape-at-delivery
**Date:** 2026-11-06

## Summary

The step shipped `reshape-initiative.mjs`, the delivery rules, and the ship change with 266 feature suites and 19 regression suites green. One P3 fix came from an old-name guard hit on the build log.

## What helped

- The script test built a scratch repo per case, so one file covered the shape, the fold, the conflict, the missing tag, and `--push` against a bare repo (`ravintio-zero/tests/test-0000353-req-001-004-reshape-script.sh`, 42 assertions).
- `git merge-tree --write-tree` gave a clean exit code for a conflict and left the working tree alone (`plan/_archive/0000353-reshape-at-delivery-2026-11-06/adr/ADR-001-replay-with-merge-tree.md`).
- The step 2 archive gave a ready format for every plan artifact.

## What slowed the work

- The full suite took about 14 minutes and printed nothing until it ended. The step waited on it at P3.
- The old-name guard failed on the build log note that quoted the old migration triggers (`Self-corrections` in `build-report.md`). The suite found it, and one edit fixed it.

## Keep

- Scratch-repo fixtures with a bare `origin` for any script that pushes.

## Change

- None filed. Backlog entry 0000269 already covers the failing suite list, and step 7 of this initiative ships it.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| None | none | none | none | none |
