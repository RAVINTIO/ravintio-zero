---
title: "Acceptance Evidence - 0000503-planned-restart-exit-code"
summary: "Checks run, security findings, and execution evidence for the PR reviewer."
---
# Acceptance Evidence - 0000503-planned-restart-exit-code

- Checks: the full suite ran in a clean clone. 442 feature suites and 19 regression suites passed. Four feature suites failed. The base commit already fails three of them: `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, and `test-0000450-req-004-report-format.sh`.
- The fourth, `test-0000379-req-002-003-005-scheduler.sh`, expected exit 1 for a restart line. The agent updated it to exit 75 and reran it: 57 of 57 pass.
- Self-corrections: 1.
- Security: no critical, high, or medium findings. Overall risk low.
- Execution: every criterion verified by running the driver in throwaway repos. The new suite passes 23 of 23 in both pack trees.
- Docs edit pass: 1 cycle, 2 sentences in ADR-0327 corrected, `prose-check.mjs` exit 0.
- OS gap: local macos, CI ubuntu and windows.
- Not verifiable: none.
