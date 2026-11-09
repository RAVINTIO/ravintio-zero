# Acceptance evidence - 0000385-faster-test-runs

- Checks: full Bash suite in a clean clone of `HEAD`, 304 feature suites and 19 regression suites passed, 1 failed. The failure, `test-0000037-req-004-remove-old-folder.sh`, is in the P0 baseline. Self-corrections: 0.
- Baseline: the P0 run on the base commit failed 3 suites. Two of them, `test-0000378-req-001-version-files.sh` and `test-0000378-req-002-003-merge-queue.sh`, passed in the later run and look load-sensitive, since the baseline ran beside the build.
- Security: no critical or high findings. Two low findings accepted. See `security-report.md`.
- Execution: 7 criteria verified by running commands. See `verification-report.md`.
- Search evidence: no program reported missing.
