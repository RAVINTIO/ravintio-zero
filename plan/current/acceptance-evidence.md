# Acceptance evidence - 0000399-smoother-activation

| Criterion | Method | Outcome |
|-----------|--------|---------|
| Activation takes one confirmation and no manual table edits | `test-0000399-req-001-activate.sh` with a fake `gh` and a bare origin | 43 passed, 0 failed |
| A test adds a step with `add-step` and the chart checks pass | `test-0000399-req-002-add-step.sh` | 25 passed, 0 failed |
| The question rule is pinned in the initiative skill | `test-0000399-req-003-004-question-rule.sh` | 16 passed, 0 failed |
| A plan-only coordinator PR skips the full suite | `test-0000399-req-005-plan-only-check.sh` | 12 passed, 0 failed |
| `resume-detect.mjs` prints no line for a migration that does not apply | `test-0000399-req-006-detect-applies.sh` | 8 passed, 0 failed |
| The coordinator start-up names the initiative skill | `test-0000399-req-007-coordinator-hooks.sh` | 11 passed, 0 failed |
| Full suite on the working tree | `run-tests.sh` | 382 feature suites and 19 regression suites passed |
| Security review | `plan/current/security-report.md` | low risk, no open finding |

Resume detection in this worktree now prints `pending migration: 0009` only. It printed 0004, 0005, 0008, and 0009 before.
