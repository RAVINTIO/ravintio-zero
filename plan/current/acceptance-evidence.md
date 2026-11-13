# Acceptance evidence - 0000386-unit-dispatch

- **Checks:** the three new suites pass. The affected suites pass. The full suite ran in 4 local shards in a clean clone with no new failing suite. Self-corrections: 1, a pinned `Done:` line in `test-0000043-req-012-progress-markers-and-resume.sh` that the intended change altered.
- **Security:** 3 findings, all Low. No critical or high finding.
- **Execution:** 9 of 9 acceptance criteria verified by running the tests and the scripts. None is `not-verifiable`.
- **Search evidence:** no program was reported missing.
- **Inherited failures:** `test-0000037-req-004-remove-old-folder.sh` and `test-0000318-req-004-merge-guard-pinned.sh`, both failing on the base commit.
- **CI:** results follow on the PR.
