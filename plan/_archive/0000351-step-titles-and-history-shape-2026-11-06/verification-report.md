# Verification report - 0000351-step-titles-and-history-shape

Started nothing. The script and the suites run from a shell.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| A fixture with N titled steps and one chore commit passes | CLI: `test-0000351-req-003-shape-check.sh` builds temp repos and runs the script | verified | Exit 0 on valid history. 21 assertions pass. |
| A mistitled step fails | CLI: same suite | verified | Exit 1, the commit hash and subject print. |
| An extra commit between steps fails | CLI: same suite | verified | Exit 1, the extra commit prints. |
| `initiative.template.md` has a `Title` column | Side effect: read the file | verified | Header row is `Step, Feature id, Title, Backlog entries, Bump, Version, Status`. |
| Ship titles the step PR | Text check in `test-0000351-req-001-004-title-rules.sh` | verified | The skill holds `{feature-id}: {Feature title}`. |
| Standards state the forms and the one-commit rule | Same suite | verified | Both standards hold the step and chore forms. |
| Plan skill and standards state the chart-format rule | `test-0000351-req-002-005-template-and-plan.sh` and the title-rules suite | verified | 18 assertions pass. |
| Real-branch run | CLI: `node ravintio-zero/scripts/check-initiative-history.mjs --base origin/main --head HEAD` | verified | Exit 1. It lists the activation commits and the 8 missing step commits. This is the expected result before the step 3 reshape (R-001). |
| Missing chart | CLI: `--chart /nonexistent` | verified | Exit 1, `chart not found`. |
