# Acceptance evidence - 0000354-steps-run-to-the-end

- Checks: the full suite passes (271 feature suites and 19 regression suites). The consistency check, the backlog index check, and the self-description check pass. Self-correct cycles: 1 in P2, the test runner rejected the new helper until `run-tests.sh` listed it.
- Security: 0 critical, 0 high, 0 medium findings. Overall risk low. See `security-report.md`.
- Execution: 12 criteria verified, 0 failed, 0 not-verifiable. A stub `claude` gave two resumes then `Blocked:`, a merge after one resume, and no resume for a bad id. Setup run twice left the record clean. The watcher printed the waiting line and no stale line.
- Search evidence: no program reported missing. `pwsh` was found at `/opt/homebrew/bin/pwsh`, and the PowerShell file parses. A run of `setup.ps1` was not made.
- Deviation: `test-0000032-req-001-bash-write-to-plan-state.sh` (c) now expects the record unchanged on a same-flags rerun.
