# Changelog (0000554-coordinator-starts-defined-stages, 15 Nov 2026)

**Feature:** Coordinator starts a defined stage without asking
**Version:** set by the merge queue at merge
**PR:** #229

## What changed

- The roadmap standards gain the rule `coord-defined-stage`. The coordinator starts a stage that the pipeline defines as next and reports the start as a status.
- The coordinator asks only at a real fork or before a human-only action, such as a merge into `main`.
- The initiative skill says that I-E Delivery starts with no question after the driver's clean end.
- The driver's clean-end summary reads `action for the human: none, the coordinator runs I-E Delivery`. Rule `driver-stop-summary` and the driver comment match.
- The suite `test-0000399-req-003-004` checks the new rule and `test-0000511-req-001-003` pins the new action text.

## Why

After the last step of initiative 0000360 merged, the coordinator asked "Go?" before I-E Delivery. The answer was always yes, so the question made the human wait.

## Deviations

- The driver change stops the driver with a `Restart:` line after the merge. The coordinator starts a new driver.

## Validation results

- The clean-clone suite shows 460 passed and 3 failed. All 3 also fail on the base commit.
- The regression suite shows 19 passed.
- The two changed suites pass: `test-0000399-req-003-004` and `test-0000511-req-001-003`.
- Security risk is low. The verification report covers AC-1 to AC-4 and NFR-001.

## Skipped phases

None.
