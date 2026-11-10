# Baseline failures

Suites that fail on the base commit. P3 reports these as inherited and stops only on other failures.

None.

The clean-clone baseline run stopped before it printed a summary. It showed two failures that depend on the machine and not on this change:

- `test-0000037-req-004-remove-old-folder.sh`: a clean clone has no `core.hooksPath`.
- `test-0000318-req-004-merge-guard-pinned.sh`: the run diffs against an `origin/initiative/0000312-guards-history-and-test-noise` ref that the clone lacks.
