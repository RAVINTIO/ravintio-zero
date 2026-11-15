# Changelog (0000562-test-impact-scan-lists-the-mirrored-pack-tree, 14 Nov 2026)

**Feature:** Test impact scan lists the mirrored pack tree
**Version:** set by the merge queue at merge
**PR:** 219

## What changed

- The plan skill's Test impact causes move to `skills/ravintio-plan/references/test-impact-causes.md`. The skill gains a `## Pack Index` row for it.
- The reference file gains a `Pack file edit` cause that lists `test-0000493-req-004-handoff-text.sh`.
- The P0 gate reference tells P0 to list `src/ravintio-zero/` and `ravintio-zero/` in `## Component Paths` for a pack file edit.
- Three suites read the scan from the reference file. The suite `test-0000562-req-001-003` covers the new text.

## Why

Step 61 of an earlier initiative edited `ravintio-zero/` only. The full suite then failed on the mirrored tree. Backlog entry 0000540 filed the gap.

## Deviations

None.

## Validation results

- The new suite passes with 21 checks.
- The full suite in a clean clone finished with five failed suites outside the changed files. See the acceptance evidence.

## Skipped phases

None.
