# Verification report - 0000568

Started: no service. Each criterion ran as a CLI or file check from the worktree root.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 the cause greps and lists | New suite `test-0000568-req-001-prose-rewrite-cause.sh` | verified | Exit 0, 6 passed, 0 failed. The cause names `ravintio-zero/tests/`, each changed sentence, and the execution plan. |
| REQ-001 AC-2 the scan names the cause and stays small | Same suite | verified | The scan text holds `Prose rewrite` and 20 lines, the cap. |
| REQ-001 AC-3 both trees match | `sync-installed.mjs --check` and the suite | verified | Exit 0. |
| NFR-001 parity | `sync-installed.mjs --check` | verified | Exit 0. |
