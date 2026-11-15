---
title: "Retrospective: 2026-11-15 - Test impact scan lists the mirrored pack tree"
summary: "A blameless review of step 18, and the changes it files."
status: "open"
---
# Retrospective: 2026-11-15 - Test impact scan lists the mirrored pack tree

> Path: `plan/retrospectives/0000562-test-impact-scan-lists-the-mirrored-pack-tree-2026-11-15.md`. Written by `ravintio-retrospective`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Mode:** run
**Subject:** 0000562-test-impact-scan-lists-the-mirrored-pack-tree
**Date:** 2026-11-15

## Summary

The step moved the scan causes to a reference file and added the `Pack file edit` cause. P3 waited more than ten hours on a full suite that could not finish. CI then found one regression the local run had shown.

## What helped

- The units were text changes, so they ran inline with no dispatch cost (build-log P2 block).
- A rerun at low load finished the full suite in about 25 minutes (build-log `Resolved:` line).

## What slowed the work

- The full suite hit the time limit at load average 26 while four steps ran at once (build-log P3 `Blocked:` line).
- The step judged `test-0000171` inherited without comparing it to the chart's baseline list (`plan/postmortems/2026-11-15-scan-moved-to-reference-file.md`).

## Keep

- Compare the full-suite failures with the chart's baseline list before ship (acceptance evidence).

## Change

- P3 compares each failed suite with the chart's known baseline failures and treats any other as new (`plan/postmortems/2026-11-15-scan-moved-to-reference-file.md`).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| P3 baseline comparison by name | validate-and-accept skill | `ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md` | A test checks the skill text | not filed, because step 18 is open to the coordinator. The coordinator files it from this record. |
