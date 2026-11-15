# Verification report - 0000567

Started: no service. Each criterion ran as a CLI or file check from the worktree root.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 every cap named | New suite `test-0000567-req-001-002-size-cap-frozen-lines.sh` | verified | Exit 0, 10 passed, 0 failed. The `Size cap` cause asks for every test, each cap value, and rejects the first match. |
| REQ-001 AC-2 lowest cap named | Same suite | verified | The cause says to plan growth against the lowest cap. |
| REQ-001 AC-3 both trees match | `sync-installed.mjs --check` | verified | Exit 0. |
| REQ-002 AC-1 suite named | Same suite | verified | The `Reference file edit` cause names `test-0000151-req-011-orchestrator-references-split.sh`. |
| REQ-002 AC-2 frozen lines and boot cap named | Same suite | verified | The cause names every base line, the boot template, and says to read the cap from the suite. |
| REQ-002 AC-3 scan within 20 lines | Same suite | verified | The scan holds 19 lines. |
| NFR-001 parity | `sync-installed.mjs --check` | verified | Exit 0. |
