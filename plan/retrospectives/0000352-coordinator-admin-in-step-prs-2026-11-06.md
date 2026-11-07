---
title: "Retrospective: 2026-11-06 - coordinator admin in step PRs"
summary: "A blameless review of step 2 of initiative 0000349 and the change it files."
status: "open"
---
# Retrospective: 2026-11-06 - coordinator admin in step PRs

**Mode:** run
**Subject:** 0000352-coordinator-admin-in-step-prs
**Date:** 2026-11-06

## Summary

The step shipped the `reserve-id.mjs` refusal, the queue item contract, and the `--delete-branch` rule with 265 feature suites green. One rework cycle came from a repo-wide test style rule.

## What helped

- Each unit wrote its test first and showed RED before the edit (`test-0000352-req-001-reserve-id-refusal.sh`, 5 failures before the change).
- The step 1 archive gave a ready format for every plan artifact (`plan/_archive/0000351-step-titles-and-history-shape-2026-11-06/`).

## What slowed the work

- The new standards test used a loop form that `test-0000164-req-008-no-process-substitution-loops.sh` bans. The failure appeared only in the full suite (`Rework: REQ-004` in `build-log.md`).
- The merge guard blocked shell commands whose text held a merge command, even inside a heredoc or a search pattern. The step switched to the Write and Edit tools for those files.
- Writing the queue rule showed a gap in the plan. The coordinator cannot reserve an id while the driver runs, because it never edits the working tree then. P2 added an `{id}` placeholder that the step fills (`Deviation` in `build-log.md`).

## Keep

- Test-first units with disjoint write targets (`execution-plan.md`, Concurrency plan).

## Change

- Make the test impact scan name repo-wide test style rules when a run adds a test file (`plan/backlog/0000362-test-impact-scan-names-test-style-rules/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Scan names style rules for new test files | plan skill | `ravintio-zero/skills/ravintio-plan/SKILL.md` | A test that the skill names the cause | backlog entry 0000362, naming this retrospective |
