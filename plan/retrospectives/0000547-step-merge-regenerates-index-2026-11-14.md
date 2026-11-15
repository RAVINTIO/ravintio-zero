---
title: "Retrospective: 2026-11-14 - Step base merge regenerates the backlog index"
summary: "A blameless review of step 3 of initiative 0000544, and the changes it files."
status: "open"
---
# Retrospective: 2026-11-14 - Step base merge regenerates the backlog index

**Mode:** run
**Subject:** 0000547-step-merge-regenerates-index
**Date:** 2026-11-14

## Summary

The step added one rule to I-D Advance and a test for it. PR 214 conflicted on the backlog index, and the agent applied the new rule to resolve it. CI passed on the first run.

## What helped

- The rule worked on its own PR. `backlog-index.mjs` rebuilt the conflicted index and `--check` passed before the push (`build-log.md`, P4 block).
- The clean-clone run separated three inherited failures from new ones (`baseline-failures.md`).

## What slowed the work

- The session resumed at P2 about 90 minutes after the rule landed. The build log then had no P2 end time and no P3 block.
- `baseline-failures.mjs check` found no baseline file. It listed every inherited suite as new. The agent then recorded the chart's list.
- A clean-clone run in a detached subshell ended with no result and cost one rerun.

## Keep

- Resolve a conflicted `plan/backlog/index.md` by rebuilding it, never by hand.

## Change

- None filed. The agent did not check the backlog for earlier entries on the baseline gap.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| None | none | none | none | none |
