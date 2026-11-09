# Acceptance evidence

- Checks: the full suite in the working tree passed 371 feature suites and 19 regression suites. A clean clone of `HEAD` passed 369 and failed 2. Both failures come from the base commit: `test-0000037-req-004-remove-old-folder.sh` and `test-0000318-req-004-merge-guard-pinned.sh`. They need the original git config, which a clean clone lacks.
- Self-corrections: 2 rework cycles in P2 (a banned word in a sample file, and a test that compared against `HEAD`). None in P3.
- Security: 0 critical or high findings. 3 informational findings, 2 mitigated and 1 accepted. See `plan/current/security-report.md`.
- Execution: 8 criteria checked by running `setup.sh` and the scripts in a scratch repo. 6 verified by running, 2 verified by test only (slot clash, threshold lowering), because the catalogue ships no pair that clashes. See `plan/current/verification-report.md`.
- Missing programs: none reported. `pwsh` found at `/opt/homebrew/bin/pwsh` and used.
- Docs edit pass: 8 changed user-facing files, 0 cycles needed, `prose-check.mjs check` exit code 0.
- Unverified: the Windows PowerShell 5.1 run of `setup.ps1`. CI checks it.
