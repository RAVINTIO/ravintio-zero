# Verification report - 0000353-reshape-at-delivery

Started nothing. The script and the suites run from a shell.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| A new branch with N + 1 commits and the old head tree | CLI: `reshape-initiative.mjs` on a scratch repo with three tagged steps and two admin commits | verified | Exit 0. Four commits: three titled steps (`0000901: Alpha work (#11)` and so on), then `0000900: Initiative admin (#12)`. The new head tree equals the old head tree. The caller's tree stayed clean. |
| Aligned admin folds into its step | CLI: same repo with `--assign {hash}=3` | verified | Step 3's tree holds `note.txt` and step 2's tree lacks it. The count stays at four. |
| No extra chore commit when the last step tree equals the head | CLI: both admin commits assigned | verified | Three commits. |
| Every step tag points at its new commit with its message | CLI: `--tags`, then `git rev-parse` and `git tag -l` | verified | Each `v1.n.0` points at its new step commit and keeps `step n`. |
| A conflicting replay exits 1, names the commit, and writes no branch | CLI: scratch repo with an unassigned admin edit that step 2 depends on | verified | Exit 1. The output names `0000902`. No `-reshaped` branch. No tag moved. |
| A missing tag or an existing branch exits 1 | CLI: scratch repos | verified | Exit 1 each time. The first names step 2. The branch stays as it was. |
| `check-initiative-history.mjs` passes on the new branch | CLI: the script runs it | verified | The output holds the history check line and exit 0. |
| No `--force` in the script, and `--push` works with no force | Source search, and CLI against a bare repo as `origin` | verified | No `--force`, `-f`, or `+` refspec. `origin` holds the new branch and the new tags, and no origin tag points at an old step commit. |
| Real repo, step 3 not yet versioned | CLI: the script on `initiative/0000349-clean-initiative-history` | verified | Exit 1 with `step 3 has no usable Version`. No branch written. |
| Delivery rules, initiative skill, and ship skill text | `test-0000353-req-005-006-delivery-and-ship.sh` | verified | 17 assertions pass. The initiative skill holds 118 lines. The ship skill names no `--force-with-lease`. |
| Consistency check | CLI: `consistency-check.mjs` | verified | Prints `clean`. |
