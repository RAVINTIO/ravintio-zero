---
title: "Retrospective: 2026-11-06 - step titles and history shape"
summary: "A blameless review of step 1 of initiative 0000349 and the change it files."
status: "open"
---
# Retrospective: 2026-11-06 - step titles and history shape

**Mode:** run
**Subject:** 0000351-step-titles-and-history-shape
**Date:** 2026-11-06

## Summary

The step shipped the `Title` column, the titled PR form, and the shape check with 262 feature suites green. One rework cycle came from a frozen-line test.

## What helped

- Two parallel units (template and plan skill, history script) finished in about two minutes each (`build-log.md` P2 block).
- The test-first order showed RED for the new title rules before any edit (`test-0000351-req-001-004-title-rules.sh`).

## What slowed the work

- An in-place edit of a start-actions line failed `test-0000151-req-011-orchestrator-references-split.sh`. The test impact scan had no cause for reference files (`Rework: REQ-001` in `build-log.md`).
- The plan assumed an archive folder name that matches no real folder. P2 corrected it (changelog, Deviations).

## Keep

- Parallel batches that follow the concurrency plan (`execution-plan.md`).

## Change

- Extend the test impact scan to skill reference files (`plan/backlog/0000361-test-impact-scan-covers-references/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Scan covers skill reference files | plan skill | `ravintio-zero/skills/ravintio-plan/SKILL.md` | A test that the skill names the cause | backlog entry 0000361, naming this retrospective |
