# Acceptance evidence - 0000547-step-merge-regenerates-index

- Criteria: 3 of 3 verified by `test-0000547-req-001-002-index-rebuild-rule.sh` (2 checks, exit 0). See `plan/current/verification-report.md`.
- Full suite in a clean clone of `HEAD`: 450 feature suites passed, 3 failed. The 3 failures are the inherited baseline from the chart: `test-0000037-req-004`, `test-0000318-req-004`, and `test-0000450-req-004`. The regression suite passed 19 of 19.
- Security: no critical or high finding. See `plan/current/security-report.md`.
- Docs edit pass: 0 cycles needed, `prose-check.mjs` exit 0 on `docs/decisions-index.md` and `docs/architecture-overview.md`.
- Self-corrections: 0.
- OS gap: local macos, CI ubuntu, windows.
