# Verification report - 0000551-refuse-symlink-style-outputs

The agent copied the pack into a scratch repo, planted links, and ran `setup.sh`. The agent removed the scratch folder afterwards.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 | CLI: `setup.sh claude-code` with a link at the style file | verified | Exit 0. The refusal line printed. The target kept its content. |
| REQ-001 AC-2 | Suite `test-0000551-req-001-002-setup-sh.sh` and `-ps1.ps1` | verified | Both suites pass. The other folder gains no file. |
| REQ-001 AC-3 | Suites above, plain install case | verified | The style file is a plain file and no refusal line prints. |
| REQ-002 AC-1 | CLI: `setup.sh codex` with a link at `AGENTS.md` | verified | Exit 0. The refusal line printed. The target holds 0 writing blocks. |
| REQ-002 AC-2 | Suites above, plain install case | verified | One writing block, no refusal line. |

The PowerShell suite ran under `pwsh` 7 on macOS: 16 passed, 0 failed.
