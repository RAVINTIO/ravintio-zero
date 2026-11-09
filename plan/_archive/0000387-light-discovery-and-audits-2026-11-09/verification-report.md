---
title: "Verification Report - 0000387-light-discovery-and-audits"
summary: "How each acceptance criterion was run and what was observed."
---
# Verification Report - 0000387-light-discovery-and-audits

The software is a set of Markdown rules and Bash tests. Verification ran the suites and read the rule text through the test helpers.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 to AC-3 | Ran `test-0000387-req-001-light-track.sh` | verified | 23 passed, 0 failed. The light-records rule lists the 13 headings of `design.template.md`. The design of this run holds the same 13 headings. |
| REQ-002 AC-1 to AC-3 | Ran `test-0000387-req-002-grouped-commits.sh` | verified | 4 passed, 0 failed. Both rules sit in the discovery records reference. |
| REQ-003 AC-1, AC-2 | Ran `test-0000387-req-003-005-coaching-checks.sh` | verified | 5 passed, 0 failed. The fixture repo holds no Mermaid fence, and the check prints `reworded-offer`. |
| REQ-004 AC-1 to AC-3 | Ran `test-0000387-req-004-audit-refresh.sh` | verified | 4 passed, 0 failed. |
| REQ-005 AC-1, AC-2 | Same test as REQ-003 | verified | The two major-bump rules pass. |
| Whole pack | Ran `bash ravintio-zero/tests/run-tests.sh` | verified | 337 feature suites and 19 regression suites passed, 0 failed. |
| Plan consistency | Ran `consistency-check.mjs` | verified | clean |
| Hook acceptance of a light design (REQ-001 AC-2) | Compared headings only, not the live hooks | not-verifiable | The gate hooks run from the installed `.claude/` copy, so no live trigger ran against a light design. The heading comparison is the evidence. |
