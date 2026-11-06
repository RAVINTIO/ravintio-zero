# Acceptance evidence - 0000355-codeql-and-branch-cleanup

- Checks: the full suite passes (276 feature suites and 19 regression suites). The consistency check, the backlog index check, and the self-description check pass. Self-correct cycles: 2 in P2. Two workflow tests expected one write scope and now expect two, and the first full run showed a stale-install skip that missed the chart's trailing comment.
- Security: 0 critical, 0 high, 0 medium findings. Overall risk low. See `security-report.md`.
- Execution: 10 criteria verified, 0 failed, 2 not-verifiable. The cleanup `run` block ran eight cases against a fake `gh` in both workflow files. The two not-verifiable criteria need GitHub: CodeQL on a PR into `initiative/**`, and the head branch gone after the squash.
- Search evidence: no program reported missing. `ruby` was found at `/usr/bin/ruby`.
- Human action: turn CodeQL default setup off in repo settings. CodeQL advanced setup does not run alongside it.
- Deviations: `ravintio-zero/tests/helpers/assert.sh` now accepts a trailing comment on the chart status line. `test-0000169-req-006` reads `helpers/unguarded-jobs.sh`, which `run-tests.sh` lists.
