# Verification report - 0000574

Started: no service. Each criterion ran as a CLI or file check from the worktree root.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 rule 6 names the order | New suite `test-0000574-req-001-rule-6-order.sh` | verified | 4 passed, 0 failed. RED before the edit with 4 failed. Rule 6 names the step table, ascending `Version` order, merge order, and the script. |
| REQ-001 AC-2 both trees match | `sync-installed.mjs --check` | verified | Exit 0. |
| REQ-002 AC-1 four columns | Run `reshape-initiative.mjs` on a temp repo in `test-0000574-req-002-003-printed-table.sh` | verified | The header row holds Step, Title, Version, and Tag. |
| REQ-002 AC-2 each row names its step | Same suite | verified | Rows for step 2 and step 1 hold the title, version, and tag. |
| REQ-002 AC-3 a failed run prints no table | Same suite, with a chart step that has no tag | verified | Exit 1 and no table in the output. |
| REQ-003 AC-1 the printed rows ascend by version | Same suite, with versions out of chart order | verified | Rows read 2 then 1. RED before the edit. |
| REQ-003 AC-2 the table matches the replay | Same suite | verified | The new branch commits run Beta then Alpha, the row order. |
| NFR-001 parity | `sync-installed.mjs --check` | verified | Exit 0. |
