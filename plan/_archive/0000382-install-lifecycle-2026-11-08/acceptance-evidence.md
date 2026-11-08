---
title: "Acceptance Evidence - 0000382-install-lifecycle"
summary: "Results for step 6, copied into the PR description."
---
# Acceptance Evidence - 0000382-install-lifecycle

- Checks: the full run passed 317 feature suites and 19 regression suites, including the PowerShell suites under `pwsh`. Self-corrections: 4 cycles, all in suites that pinned old setup behaviour.
- Security: no critical or high findings are open. See `plan/current/security-report.md`.
- Execution: each acceptance criterion is `verified`. See `plan/current/verification-report.md`.
- Not verifiable: the CI step for the facts file runs on GitHub, so it counts as validated after the first CI run.
- Search evidence: `pwsh` found at `/opt/homebrew/bin/pwsh` with `which pwsh`.
