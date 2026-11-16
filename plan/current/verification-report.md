# Verification report - 0000559

Started: no service. Each criterion ran as a CLI or file check from the worktree root.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 the baseline comes first among the artifact actions | New suite `test-0000559-req-001-baseline-first.sh` | verified | Exit 0, 11 passed, 0 failed. RED before the edit with 5 failed. |
| REQ-001 AC-2 the decision rows follow the pre-flight and precede the baseline | Same suite | verified | Pre-flight is step 2, decisions step 3, baseline step 4. |
| REQ-001 AC-3 cited step numbers match the order | Same suite | verified | The skill, the roadmap standards, and the start actions file cite the new numbers. |
| NFR-001 parity | `sync-installed.mjs --check` | verified | Exit 0. |
| Baseline overlap | The baseline run started at 05:33:50Z, before any P0 artifact | verified | The output at `/tmp/step15/baseline.out` was complete before P3 began. |
