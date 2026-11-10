# Changelog (0000462-tests-without-git-identity, 10 Nov 2026)

**Feature:** Tests catch runner-only failures
**Version:** set by the merge queue at merge
**PR:** 165

## What changed

- `run-tests.sh` and `run-tests.ps1` give each suite a temporary global git config with `user.useConfigOnly` set. They hide the system config and clear the author, committer, and `EMAIL` variables. A commit with no identity now fails locally.
- `helpers/git-isolation.sh` holds `isolate_git_env` and `remove_git_isolation`.
- `setup.sh` strips a BOM from the first line of a boot file before it compares the pack line. A pack `CLAUDE.md` that Windows PowerShell 5.1 wrote is no longer copied to `ravintio-overrides/instructions/`.
- Two new suites: `test-0000462-req-001-git-identity-isolation.sh` and `test-0000462-req-002-bom-first-line-readers` in Bash and PowerShell.
- ADR 0303 records the decision.

## Why

PR #136 passed locally and failed two CI jobs. A suite relied on the global git identity, and `doctor` did not strip a BOM. Backlog entry 0000414 asked for a local run that fails on both.

## Deviations

- P2 ran inline without subagents, because the units are small and share the runners.
- The BOM suite found a third defect in `setup.sh`, and the step fixed it.

## Validation results

- The isolation suite fails 6 checks before the helper exists and passes after it.
- The BOM suite fails 1 check before the `setup.sh` fix and passes after it.
- With the PR #136 fixes reverted, the identity check and the `doctor` check both fail.

## Skipped phases

None.
