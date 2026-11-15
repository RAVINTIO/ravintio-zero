# Acceptance evidence

- Checks: the requirement test passes (7 of 7). The local full suite shows 463 feature suites passed and 1 failed, an inherited baseline failure. The regression suite shows 19 passed. The clean-clone result follows in the build log.
- Self-correction cycles: 0.
- Security: low risk. Two informational findings, both false-positive (`plan/current/security-report.md`).
- Execution: AC-1, AC-2, AC-3, and NFR-001 verified by running `ravintio-zero/tests/test-0000546-req-001-restore-written-files.sh`.
- Search evidence: no program reported missing.
- Docs edit pass: 3 files checked, `prose-check.mjs` exit 0, 0 cycles.
- Deviation: U3 writes `docs/decisions-index.md` and not `docs/about.md`, and ADR-0347 is `accepted` before ship. Both are in the build log.
