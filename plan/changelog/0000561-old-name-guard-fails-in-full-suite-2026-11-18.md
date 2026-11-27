# Changelog (0000561-old-name-guard-fails-in-full-suite, 18 Nov 2026)

**Feature:** Old-name guard fails in the full suite
**Version:** set by the merge queue at merge
**PR:** 247

## What changed

`test-0000189-req-007-old-name-guard.sh` matches its file allowlist in Bash. It no longer pipes the allowlist to `grep -q`. Three new cases run the guard with a failing `grep` on the path.

## Why

A full-suite run sometimes reported a hit on an allowlisted file, such as `ravintio-zero/migrations/0005-initiative-rename.md`. The suite passed alone. The piped `grep -q` can end early. Under `pipefail`, that early exit made the match fail. The hit path and line changed from run to run.

## Deviations

The chart row named a stable copy of the tree or a fix to an earlier suite. No suite changes the tree, so neither applies. The fix removes the cause. The allowlist and the old-name pattern keep their entries.

## Validation results

The full suite in a clean clone shows only the 3 inherited failures: `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, and `test-0000450-req-004-report-format.sh`. The guard suite passed 15 of 15 solo runs and passed in the full run. The flake does not reproduce on demand.

## Skipped phases

None
