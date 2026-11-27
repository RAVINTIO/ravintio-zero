---
title: "Postmortem: 2026-11-15 - Scan moved to a reference file broke pins"
summary: "A blameless record of why three suites failed after the scan text moved, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-15 - Scan moved to a reference file broke pins

> Path: `plan/postmortems/2026-11-15-scan-moved-to-reference-file.md`. Written by `ravintio-postmortem`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.
> Copy no credential from a log. Name the file and the line instead.

**Trigger:** P2 self-correction
**Feature:** 0000562-test-impact-scan-lists-the-mirrored-pack-tree
**Date:** 2026-11-15

## Summary

The change moved the scan causes into a reference file. Three suites read the scan from `SKILL.md` and failed. A fourth, `test-0000171`, asserted that the plan skill has no `references` folder. CI found it. The fix pointed each suite at the new layout.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-14T15:11:51Z | RED for the REQ-001 to REQ-003 suite. | build-log P2 block |
| 2026-11-14T15:12:23Z | GREEN, with a `Rework:` line for three pins. | build-log P2 `Rework:` line |
| 2026-11-15T13:02:05Z | CI on PR 219 fails `test-0000171-req-004-no-skill-bundling` on a folder assertion. The local full run showed the same failure and the step read it as inherited. | `gh pr checks 219` |

First missed chance to catch it: P1 Plan. The test impact table did not list suites that read the scan text.

## 5 whys

1. Three suites failed after the move.
2. They grep `SKILL.md` for the scan wording.
3. The plan listed the new test but not the suites that pin the old text.
4. The test impact step greps for counts and names, and not for the text being moved.
5. The scan has no cause for text that moves between files.

**Gap:** The plan skill's test impact step has no cause for moved text.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Point the four suites at the new layout | done | step 18 | `ravintio-zero/tests/` | The named suites and CI pass | commit on this branch |
| preventive | none, because the `Pack file edit` cause added in this step lists the pinned suites and the scan text now sits in one reference file | none | none | none | none | none |
| detective | none, because the full run catches a failed pin before P3 ends | none | none | none | none | none |
