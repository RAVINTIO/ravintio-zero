# Changelog (0000564-test-impact-hook-pins, 15 Nov 2026)

**Feature:** Test impact scan names hook pins
**Version:** set by the merge queue at merge
**PR:** 223

## What changed

The plan skill's Test impact scan has a `Hook change` cause. It lists four greps for a run that adds, removes, or changes a hook. They are the hook name, hook count words, the `expected-after.txt` fixture with `pack-facts`, and the margin or status text. A new suite checks the cause in both pack trees.

## Why

Step 51 of an earlier initiative added a hook and cut a margin. Six suites pinned the old behaviour, the plan named three, and the full suite found the rest in P2.

## Deviations

None.

## Validation results

The full suite in a clean clone passes apart from three inherited failures. This step folds in backlog entry 0000523.

## Skipped phases

None
