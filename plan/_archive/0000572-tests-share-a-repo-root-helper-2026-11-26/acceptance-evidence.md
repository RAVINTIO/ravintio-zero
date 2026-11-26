# Acceptance evidence - 0000572

## Checks

- `test-0000572-req-001-repo-root-helpers.sh` passes 9 of 9 from `src/ravintio-zero/tests/` and from `ravintio-zero/tests/`.
- `test-0000572-req-002-standard-and-adoption.sh` passes 14 of 14 from both trees.
- The step-clock and handoff-text suites pass from both trees after they moved to `repo_root`. The wording, prose, quiet-output, and process-substitution suites pass from both trees.
- `sync-installed.mjs --check` exits 0.

## Full suite

The clean-clone full run passed 487 feature suites and failed 3. The 3 are the inherited baseline failures `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, and `test-0000450-req-004-report-format.sh`. `baseline-failures.mjs check` exits 0 and lists each as `inherited:`.

## Security

No finding above low. See `plan/current/security-report.md`.

## Execution

All criteria verified by running the suites. See `plan/current/verification-report.md`.

## Docs edit pass

One changed doc sentence in `docs/architecture-overview.md`. `prose-check.mjs check --files docs/architecture-overview.md` exits 0.

## RED and GREEN for U3 and U4

U3 is a sync unit and U4 is a docs unit. Neither has its own executable check. The build log records their markers per the chart row for 0000410.
