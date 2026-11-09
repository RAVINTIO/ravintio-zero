---
title: "Acceptance Evidence - 0000387-light-discovery-and-audits"
summary: "Results, counts, and cites for the PR description."
---
# Acceptance Evidence - 0000387-light-discovery-and-audits

- Checks: the full pack suite passed with 337 feature suites and 19 regression suites. 0 failed. Self-corrections: 2 (the 0000377 size cap and the runner fixture list).
- Plan check: `consistency-check.mjs` clean.
- Security: 0 critical, 0 high. Overall risk Low (`plan/current/security-report.md`).
- Execution: every criterion verified by its suite. One criterion is not-verifiable live: the gate hooks run from the installed `.claude/` copy, so the heading comparison stands in (`plan/current/verification-report.md`).
- Deviations: the boot template cap rose from 3,600 to 3,800 bytes (`ravintio-zero/tests/test-0000151-req-011-orchestrator-references-split.sh:97`). The 0000377 SKILL.md cap rose from 8,700 to 9,000 bytes.
- Known older breach: `check-entry-wording.mjs` flags lines 28 and 29 of `test-0000151-req-011-orchestrator-references-split.sh`. Both lines pre-date this step.
