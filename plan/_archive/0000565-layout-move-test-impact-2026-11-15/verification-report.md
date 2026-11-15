# Verification report - 0000565

Started: no service. Each criterion ran as a CLI or file check from the worktree root.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 cause named | `grep -c "Path move"` on the reference file | verified | Count 1 in `src/ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md`. |
| REQ-001 AC-2 greps and state files listed | New suite `test-0000565-req-001-path-move-cause.sh` | verified | Exit 0, 6 passed, 0 failed. The cause names `$ZERO_DIR/..`, `SCRIPT_DIR/../..`, `plan/state/prose-baseline.json`, and its trigger. |
| REQ-001 AC-3 both trees match | `sync-installed.mjs --check` | verified | Exit 0. |
| NFR-001 parity | Same check | verified | Exit 0. |
