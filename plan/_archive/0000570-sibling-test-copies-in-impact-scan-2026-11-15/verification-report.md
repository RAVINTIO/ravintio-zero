# Verification report - 0000570

Started: no service. Each criterion ran as a CLI or file check from the worktree root.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 the scan holds the sibling-copy line | New suite `test-0000570-req-001-sibling-copy-line.sh` | verified | Exit 0, 5 passed, 0 failed. RED before the edit with 3 failed. The section names `tests/regression/`, `same name`, and `list the match`. |
| REQ-001 AC-2 the scan stays small | Same suite | verified | The scan text holds 21 lines, the cap. |
| REQ-001 AC-3 both trees match | `sync-installed.mjs --check` and the suite | verified | Exit 0. |
| NFR-001 parity | `sync-installed.mjs --check` | verified | Exit 0. |
