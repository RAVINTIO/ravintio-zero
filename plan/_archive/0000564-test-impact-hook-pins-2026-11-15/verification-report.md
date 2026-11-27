# Verification report - 0000564

Started: no service. Each criterion ran as a CLI or file check from the worktree root.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 cause named | `grep -c "Hook change"` on the reference file | verified | Count 1 in `src/ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md`. |
| REQ-001 AC-2 four targets listed | New suite `test-0000564-req-001-hook-change-cause.sh` | verified | Exit 0, 7 passed, 0 failed. The cause names the hook name, count words, the fixture, `pack-facts`, and the margin text. |
| REQ-001 AC-3 both trees match | `sync-installed.mjs --check` | verified | Exit 0. |
| NFR-001 parity | Same check | verified | Exit 0. |
