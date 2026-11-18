# Acceptance evidence - 0000561-old-name-guard-fails-in-full-suite

- Full suite in a clean clone: 500 passed, 3 failed. The 3 come from the base, per `plan/current/baseline-failures.md`. The baseline check reports no new suite.
- Guard suite: 8 passed, 0 failed. Fifteen solo runs passed.
- Archetype gates: none installed, exit 0.
- Pack trees: `sync-installed.mjs --check` exits 0.
- Docs edit pass: 2 docs, 1 cycle, `prose-check.mjs` exit 0. The subagent split one sentence in the changelog.
- Security: 0 critical or high findings. One informational finding, a false positive.
- Self-corrections: 0.
- Execution evidence: see `plan/current/verification-report.md`. The flaky failure does not reproduce on demand, so REQ-001 AC-1 rests on the cause test and the clean full run.
