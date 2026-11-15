# Verification report - 0000563

Started: no service. Each criterion ran as a CLI or file check from the worktree root.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 cause named | `grep -c "Output order"` on the reference file | verified | Count 1 in `src/ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md`. |
| REQ-001 AC-2 both readers listed | New suite `test-0000563-req-001-output-order-cause.sh` | verified | Exit 0, 5 passed, 0 failed. The cause names the line text, the last line, and the tests folder. |
| REQ-001 AC-3 both trees match | `sync-installed.mjs --check` | verified | Exit 0. |
| NFR-001 parity | Same check | verified | Exit 0. |
