---
title: "Retrospective: 2026-11-07 - Safe parallel commits"
summary: "A blameless review of step 8 of initiative 0000349, and the change it files."
status: "open"
---
# Retrospective: 2026-11-07 - Safe parallel commits

**Mode:** run
**Subject:** 0000359-safe-parallel-commits
**Date:** 2026-11-07

## Summary

The step added the shared-tree git rules to the orchestrator and implement skills, and the path-limited commit and amend ban to the dispatch standard. The suite passes with 286 feature and 19 regression suites. Evidence: `plan/_archive/0000359-safe-parallel-commits-2026-11-07/build-report.md`.

## What helped

- The plan's test impact scan named the byte and line caps, so the orchestrator rule was sized to fit before it was written (`execution-plan.md`, `## Test impact`).
- Each new test failed first and passed after the edit (`build-log.md`, P2 notes).

## What slowed the work

- The orchestrator skill held 8779 of 9000 bytes, so the fuller rule went into the implement skill (`risk-register.md`, R-001).
- A commit made while the full suite ran made the runner's changed-tree check fail `test-0000010`. A rerun passed (`build-log.md`, P2 notes).

## Keep

- Size a new skill rule against its cap in the plan, before the edit (`risk-register.md`, R-001).

## Change

- Free headroom in the orchestrator skill by moving a section into a reference file (`build-log.md`, P1 notes).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Move a section out of the orchestrator skill to restore byte headroom | Pack maintainers | `ravintio-zero/skills/ravintio-orchestrator/SKILL.md` | The cap tests pass with a lower byte count | `plan/backlog/0000371-orchestrator-skill-byte-headroom/entry.md` |
