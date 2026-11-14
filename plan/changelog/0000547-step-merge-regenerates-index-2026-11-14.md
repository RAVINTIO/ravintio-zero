# Changelog (0000547-step-merge-regenerates-index, 14 Nov 2026)

**Feature:** Step base merge regenerates the backlog index
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- The I-D Advance rules in `ravintio-zero/standards/roadmap-standards.md` gain the rule `advance-index-rebuild`. After a manual merge of the base branch, a step runs `node ravintio-zero/scripts/backlog-index.mjs` and commits the result before the push.
- The rule names the CI check `Check the backlog index` that fails on a stale index.
- The suite `test-0000547-req-001-002-index-rebuild-rule.sh` checks the rule and the mirrored `src/ravintio-zero/` tree.
- The living docs record the change.

## Why

The merge queue rebuilds the index after its own base merges. A step that merges the base by hand got no such help, so `Check the backlog index` failed on its PR. Backlog entry 0000517 reported it.

## Deviations

None.

## Validation results

- Full suite in a clean clone: 450 feature suites passed and 3 failed. The 3 are the inherited baseline from the chart.
- No security finding above informational.
- `prose-check.mjs` exits 0 on the changed docs.

## Skipped phases

None.
