# Changelog (0000545-clear-feature-id-at-ship, 14 Nov 2026)

**Feature:** Ship leaves plan/.feature-id behind
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

- Ship Step 8 deletes `plan/.feature-id` with the other sentinels.
- `scripts/shared-files.mjs` resolves a base-merge conflict on `plan/.feature-id`. A file the PR branch deleted stays deleted. A file the PR branch holds keeps the PR branch text.
- The roadmap standards list the new shared file.
- The suites `test-0000545-req-001` and `test-0000545-req-002` cover the change. ADR 0344 records the decision.

## Why

Each squash carried the last step's id in `plan/.feature-id` onto the initiative branch. Step 43 then conflicted on the file at its base merge.

## Deviations

None.

## Validation results

- Both new suites pass.
- The full suite result is in the verification report.

## Skipped phases

None.
