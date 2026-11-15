# Verification report - 0000566

Started: no service. Each criterion ran as a CLI or file check from the worktree root.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 cause named | `grep -c "History move"` on the reference file | verified | Count 1 in `src/ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md`. |
| REQ-001 AC-2 grep and listing named | New suite `test-0000566-req-001-history-move-cause.sh` | verified | Exit 0, 6 passed, 0 failed. The cause names its trigger, `plan/_archive/`, `ravintio-zero/tests/`, and the listing. |
| REQ-001 AC-3 both trees match | `sync-installed.mjs --check` | verified | Exit 0. |
| NFR-001 parity | Same check | verified | Exit 0. |
