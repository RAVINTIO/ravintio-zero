---
title: "Retrospective: 2026-11-11 - Coordinator status view"
summary: "A blameless review of the status view run, and the change it files."
status: "open"
---
# Retrospective: 2026-11-11 - Coordinator status view

**Mode:** run
**Subject:** 0000450-coordinator-status-view
**Date:** 2026-11-11

## Summary

The coordinator now has a status script, watcher events, and a driver line for a queue failure. The run took about 88 minutes. The full suite and the base merge took most of that time.

## What helped

- Three independent files went to three parallel subagents, and each came back within about four minutes (build log P2 batch line).
- The status script ran against the live initiative root before the PR and showed the real state (verification report, "Status script" rows).

## What slowed the work

- The branch conflicted with the initiative branch at ship. The base had taken ADR 0313, and two living docs and `plan/.feature-id` conflicted (commit bc6b1144).
- The manual merge left the backlog index stale, and CI failed twice on it before a rebuild (CI run 42957335263, commit 297b852d).
- Two of three dispatched units wrote code before the test, so the red run came afterwards (build log P2 deviation lines).

## Keep

- Dispatch independent files as parallel subagents with the requirement file named in the brief (build log P2).

## Change

- Tell a step to rebuild the backlog index after any manual base merge (backlog entry 0000517).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Step rebuilds the backlog index after a manual base merge | ship skill and roadmap standards | `src/ravintio-zero/standards/roadmap-standards.md` | `backlog-index.mjs --check` in CI | `plan/backlog/0000517-step-merge-regenerates-index/entry.md`, from the 0000450 retrospective |
