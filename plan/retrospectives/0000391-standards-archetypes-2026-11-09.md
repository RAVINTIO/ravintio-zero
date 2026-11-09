---
title: "Retrospective: 2026-11-09 - standards archetypes"
summary: "A blameless review of the standards archetypes run, and the changes it files."
status: "open"
---
# Retrospective: 2026-11-09 - standards archetypes

> Path: `plan/retrospectives/0000391-standards-archetypes-2026-11-09.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000391-standards-archetypes
**Date:** 2026-11-09

## Summary

The step shipped an override resolver, a protected-rule list, four archetypes, an `archetype` command, and a P3 gate check. It ran in about two hours with two rework cycles.

## What helped

- The concurrency plan let three units run at once in two batches (build-log P2 block).
- Writing each test before the code gave a RED line for five of six units (build-log RED markers).
- The chart decision for the resolver told the step what to do before it started (`initiative.md` Decisions, step 15).

## What slowed the work

- The wording allowlist test caught a banned word late, in the full suite (postmortem `2026-11-09-archetype-content-banned-word.md`).
- Two checks diffed against `HEAD` and tested nothing (postmortem `2026-11-09-test-diffed-against-head.md`).
- One unit returned an empty report, so the RED result went unlogged (build-log P2 Done line for U2).

## Keep

- Dispatch units from the concurrency plan with a test-first brief (build-log P2 block).

## Change

- Add a scan cause for new pack content files (backlog 0000415).
- Name the diff-against-`HEAD` pattern in the testing standard (backlog 0000416).
- Require four fields in every unit report (backlog 0000417).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Scan cause for new pack content | pack maintainers | `ravintio-zero/skills/ravintio-plan/SKILL.md` | a test that reads the scan | 0000415 |
| Rule against diffs with a moving ref | pack maintainers | `ravintio-zero/standards/testing-standards.md` | a style check | 0000416 |
| Four-field unit report | pack maintainers | `ravintio-zero/standards/agent-dispatch-standards.md` | a test that reads the standard | 0000417 |
