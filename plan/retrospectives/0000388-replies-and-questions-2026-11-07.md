---
title: "Retrospective: 2026-11-07 - Replies and questions"
summary: "A blameless review of step 12 of initiative 0000360, and the changes it files."
status: "open"
---
# Retrospective: 2026-11-07 - Replies and questions

> Path: `plan/retrospectives/0000388-replies-and-questions-2026-11-07.md`. Written by `ravintio-retrospective`.

**Mode:** run
**Subject:** 0000388-replies-and-questions
**Date:** 2026-11-07

## Summary

The step shipped the time prefix, the clearer warning, the agreement rule, and the question rule with one rework loop. The full Bash suite passed (307 feature, 19 regression).

## What helped

- Four units ran in two batches against a written plan, with no conflicting edits (build log `Parallel task batches: 2`).
- Each unit wrote its test first and saw it fail, so the pins it broke surfaced at once (`Rework:` lines in the build log).

## What slowed the work

- The orchestrator `SKILL.md` grew past a stricter cap that the plan did not name (`tests/test-0000377-req-001-context-hygiene-reference.sh`, cap 8700).
- The hand run of `test-0000010-pack-quality-improvements.sh` fails 15 checks on the base commit too, which made a clean full-suite read slower (`acceptance-evidence.md`).

## Keep

- Put new rule text behind anchors in a reference file, so the skill stays under its cap (`orchestrator-p0-coaching.md`, `orchestrator-discovery-coaching.md`).

## Change

- Make the test impact scan list every cap of an edited skill (`plan/backlog/0000406-scan-every-size-cap/entry.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Scan every size cap for an edited skill | pack maintainers | `skills/ravintio-plan/SKILL.md` | A test of the scan text | 0000406 |
