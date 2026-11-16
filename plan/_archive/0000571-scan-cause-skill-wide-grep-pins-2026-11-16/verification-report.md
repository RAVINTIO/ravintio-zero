# Verification report - 0000571

Started: no service. Each criterion ran as a CLI or file check from the worktree root.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 the cause holds the skill-wide pin sentence | New suite `test-0000571-req-001-skill-wide-grep-pin.sh` | verified | Exit 0, 6 passed, 0 failed. RED before the edit with 4 failed. The cause names `every skill`, `file name, command, or flag`, `List each match`, and the example suite. |
| REQ-001 AC-2 the scan stays small | Same suite | verified | The scan text holds 21 lines, the cap. |
| REQ-001 AC-3 both trees match | `sync-installed.mjs --check` and the suite | verified | Exit 0. |
| NFR-001 parity | `sync-installed.mjs --check` | verified | Exit 0. |
