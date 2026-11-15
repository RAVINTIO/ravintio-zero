# Verification report - 0000562

Started: no service. Each criterion ran as a CLI or file check from the worktree root.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 causes move | `grep -c "Pack file edit"` on the reference file | verified | Count 1 in `src/ravintio-zero/skills/ravintio-plan/references/test-impact-causes.md`. |
| REQ-001 AC-2 pointer | `grep -n test-impact-causes` on `SKILL.md` | verified | Pack Index row at line 86, scan section pointer at line 92. |
| REQ-002 AC-1 cause named | New suite `test-0000562-req-001-003-pack-file-edit-cause.sh` | verified | Exit 0, 21 passed, 0 failed. |
| REQ-002 AC-2 mirrored edit | Same suite | verified | The cause says one unit edits both trees. |
| REQ-003 AC-1 rule present | `grep -n "Component Paths"` on the P0 gate reference | verified | Rule at line 32. |
| NFR-001 size | `wc -c` on `SKILL.md` | verified | 13262 bytes, under 13947. |
| NFR-002 parity | `sync-installed.mjs --check` | verified | Exit 0. |
