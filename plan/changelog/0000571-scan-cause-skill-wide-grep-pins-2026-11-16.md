# Changelog (0000571-scan-cause-skill-wide-grep-pins, 16 Nov 2026)

**Feature:** Test impact scan covers skill-wide grep pins
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

The `Skill-text budget` cause in the plan skill's `test-impact-causes.md` now covers a run that adds a file name, command, or flag to a `SKILL.md`. The cause says to grep for suites that loop over every skill and match the term, and to list each match. A new suite checks the sentence and the scan size in both pack trees.

## Why

Feature 0000383 added `run-tests.sh` to the plan skill. `test-0000151-req-008-quiet-test-output.sh` greps every `SKILL.md` for that command and failed in the full suite. The scan now names that pin at plan time.

## Deviations

The entry suggests a new cause. The scan held 21 lines, the cap in five suites. The sentence extends the existing `Skill-text budget` line, so no cap changed.

## Validation results

The full suite passes apart from the inherited `test-0000450-req-004-report-format.sh`. This step folds in backlog entry 0000404.

## Skipped phases

None
