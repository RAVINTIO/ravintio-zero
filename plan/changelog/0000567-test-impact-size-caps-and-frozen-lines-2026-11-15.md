# Changelog (0000567-test-impact-size-caps-and-frozen-lines, 15 Nov 2026)

**Feature:** Test impact scan covers size caps and frozen lines
**Version:** set by the merge queue at merge
**PR:** 227

## What changed

The `Size cap` cause now says to list every cap test with its value. It also says to plan growth against the lowest cap. The `Reference file edit` cause now names `test-0000151-req-011-orchestrator-references-split.sh`. That suite freezes every base line of the orchestrator skill and caps the boot template. A new suite checks both causes in both pack trees.

## Why

A unit grew the orchestrator skill to 8710 bytes. That broke a stricter cap that the scan had not listed. A first edit in another step changed a base line and the boot templates, and two checks failed.

## Deviations

Entry 0000526 names a 3800 byte boot cap. The suite holds 4000 now, so the cause names the suite and says to read the cap from it.

## Validation results

The full suite in a clean clone passes apart from three inherited failures. This step folds in backlog entries 0000406 and 0000526.

## Skipped phases

None
