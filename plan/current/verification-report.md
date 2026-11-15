# Verification report - 0000568

Started: no service. Each criterion ran as a CLI or file check from the worktree root.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 the cause greps each changed sentence | New suite `test-0000568-req-001-prose-rewrite-cause.sh` | verified | Exit 0, 6 passed, 0 failed. The cause names `ravintio-zero/tests/` and each changed sentence. |
| REQ-001 AC-2 the cause asks for a list of matches | Same suite | verified | The cause says to list the matches in the execution plan. |
| REQ-001 AC-3 the scan names the cause | Same suite | verified | The scan text of the plan skill and its reference holds `Prose rewrite`. |
| REQ-001 AC-4 the scan stays small | Same suite | verified | The scan holds 20 lines, the cap. |
| REQ-001 AC-5 both trees match | `sync-installed.mjs --check` and the suite | verified | Exit 0. |
| NFR-001 parity | `sync-installed.mjs --check` | verified | Exit 0. |
