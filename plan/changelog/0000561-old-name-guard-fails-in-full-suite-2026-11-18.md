# Changelog (0000561-old-name-guard-fails-in-full-suite, 18 Nov 2026)

**Feature:** Old-name guard fails in the full suite
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

`test-0000189-req-007-old-name-guard.sh` matches its file allowlist in Bash. It no longer pipes the allowlist to `grep -q`. Three new cases run the guard with a failing `grep` on the path.

## Why

A full-suite run sometimes reported a hit on an allowlisted file, such as `ravintio-zero/migrations/0005-initiative-rename.md`. The suite passed alone. The piped `grep -q` can end early, and under `pipefail` that ended the match with a failure. The hit path and line changed from run to run.

## Deviations

The chart row named a stable copy of the tree or a fix to an earlier suite. No suite changes the tree, so neither applies. The fix removes the cause. The allowlist and the old-name pattern keep their entries.

## Validation results

See the build log for the full-suite result.

## Skipped phases

None
