---
title: "Acceptance Evidence - 0000393-session-integrity-and-guards"
summary: "Results for the PR description."
---
# Acceptance Evidence

- Checks: 328 feature suites and 19 regression suites passed. The runner noted a changed tree because commits landed mid-run. CI gives the clean run. Self-corrections: 0.
- Security: no critical or high finding. Overall risk low. See `security-report.md`.
- Execution: every acceptance criterion was verified by running the hook or script. See `verification-report.md`.
- Not verifiable here: the PowerShell suites (`*.ps1`). Their pins were edited by hand. The Windows CI job runs them.
