# Changelog (0000547-step-merge-regenerates-index, 14 Nov 2026)

**Feature:** Step base merge regenerates the backlog index
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- `### I-D Advance` in the roadmap standards gains the rule `advance-index-rebuild`. After a manual merge of the base branch, a step runs `backlog-index.mjs` and commits the result before the push.
- The rule names the `Check the backlog index` step of the `validate-branch` job as the check that fails on a stale index.
- The suite `test-0000547-req-001-002` covers the rule in both pack trees.
- The architecture overview names the rule in its merge queue paragraph.

## Why

On 2026-11-11 step 29 merged the initiative branch by hand and left `plan/backlog/index.md` stale. CI failed twice and one more commit fixed it.

## Deviations

None.

## Validation results

- The new suite passes.
- The full suite result is in the verification report.

## Skipped phases

None.
