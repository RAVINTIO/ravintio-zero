# Changelog (0000578-plan-lists-pass-signals, 18 Nov 2026)

**Feature:** Plan lists every way a check can pass
**Version:** set by the merge queue at merge
**PR:** 248

## What changed

The plan skill has a new `## Pass signal paths` section. It applies when a requirement judges another component by its exit code. It tells the plan author to name the pass signal, list each path that produces it, and write one acceptance criterion for each path. The list includes the failure paths of any launcher between the check and the component. A new suite checks the wording and the skill size in both pack trees.

## Why

The hook check treated exit 2 as a pass for a guard. `guard-run.mjs` also exits 2 for a guard it cannot run, so a missing guard passed. The plan now asks for each path before the author builds the check.

## Deviations

None.

## Validation results

The full suite passes apart from the three inherited suites `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, and `test-0000450-req-004-report-format.sh`. This step folds in backlog entry 0000529.

## Skipped phases

None
