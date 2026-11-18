# Changelog (0000574-delivery-pr-lists-steps-in-version-order, 16 Nov 2026)

**Feature:** Delivery PR lists steps in version order
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

Rule 6 of I-E Delivery now says the step table lists steps in ascending `Version` order, which is merge order. `reshape-initiative.mjs` prints that table with step, title, version, and tag after its `wrote` lines. Two new suites check the rule text and the printed order.

## Why

The first body of initiative PR #202 listed steps in chart order, so the `Version` column ran out of order. The coordinator sorted the table by hand.

## Deviations

None. The replay already sorted by version, so only the table and the rule text were missing.

## Validation results

Impacted suites pass. The full suite shows 3 inherited failures and no new ones. The security review found 2 informational items. See the acceptance evidence in the PR description.

## Skipped phases

None
