# Verification report - 0000550-no-head-diffs-in-tests

Started: no service. The check is a bash suite, so the agent ran it directly with `bash`.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 rule present | Ran the suite | verified | `assert_rule tests-no-head-diff` passed with the terms `HEAD`, `moving ref`, `working tree` |
| REQ-001 AC-2 pack copies match | Ran `sync-installed.mjs --check` | verified | Exit 0 |
| REQ-002 AC-1 clean tree passes | Ran the suite on the real tests folder | verified | Offender list empty, 3 passed, 0 failed |
| REQ-002 AC-2 planted diff fails | Ran the suite on a scratch folder with 6 bad and 4 good files | verified | The check flagged exactly the 6 bad files |
