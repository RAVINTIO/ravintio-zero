# Changelog (0000577-plan-lists-change-shapes, 16 Nov 2026)

**Feature:** Plan lists the change shapes a diff reader must handle
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

The plan skill's `test-impact-causes.md` has a new `Diff reader` cause. It fires when a unit reads a git diff or a file list. It tells the plan author to name a test world for each of add, rename, and delete. A new suite checks the wording and the scan size in both pack trees.

## Why

The id-collisions module skipped a backlog entry that a PR had renamed. Git lists a rename apart from an add, and every test world added its files as new. The scan now prompts for each change shape at plan time.

## Deviations

The scan held 21 lines, the cap in six suites. The `New test file` and `Non-suite file` causes now share one line, which frees a line for the new cause. No cap changed.

## Validation results

The full suite passes apart from the inherited `test-0000450-req-004-report-format.sh`. `test-0000039-req-001-003-ps1-setup-hardening.ps1` failed once under parallel load and passes alone. This step folds in backlog entry 0000516.

## Skipped phases

None
