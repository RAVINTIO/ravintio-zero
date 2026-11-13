# Baseline failures

Suites that fail on the base commit. P3 reports these as inherited and stops only on other failures.

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`

The base-commit clean-clone run showed the same two failures before this step changed any file. They depend on the clone, not on the change. A clean clone has no `core.hooksPath`. It also lacks the `origin/initiative/0000312-guards-history-and-test-noise` ref that the second suite diffs against.
