# Verification report - 0000554-coordinator-starts-defined-stages

Started nothing. The checks run shell suites and one driver run against stub steps.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| AC-1 Standards hold the rule | CLI: `bash ravintio-zero/tests/test-0000399-req-003-004-question-rule.sh` | verified | Exit 0. Checks on `coord-defined-stage`, the status report, and the real-fork wording pass. |
| AC-2 Skill starts delivery without a question | CLI: same suite | verified | Exit 0. The check on the skill line passes. |
| AC-3 Clean-end action text | CLI: `bash ravintio-zero/tests/test-0000511-req-001-003-stop-summary.sh` | verified | Exit 0. The driver ran two stub steps. Its summary line holds `none, the coordinator runs I-E Delivery`. |
| AC-3 Other actions stay | CLI: same suite | verified | Exit 0. The `Restart:`, `Setup:`, and other-stop action checks pass. |
| AC-4 Test holds the rule | Side effect: grep of both trees | verified | Both `src/ravintio-zero/` and `ravintio-zero/` hold the rule, the skill line, and the test. |
| NFR-001 Skill length | CLI: four length suites | verified | The skill has 117 lines. The skill text total is under 1720. |
