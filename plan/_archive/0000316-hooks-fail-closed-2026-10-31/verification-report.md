---
title: "Verification Report - 0000316-hooks-fail-closed"
summary: "Each acceptance criterion, run against a scratch project."
---
# Verification Report - 0000316-hooks-fail-closed

I ran setup in a scratch git project, then ran the wired hook commands from a subfolder with `CLAUDE_PROJECT_DIR` set.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| Each hook in `.claude/settings.json` runs from a subfolder | Ran all 11 wired commands from `ravintio-zero/sub` in `test-0000316-req-001-002-setup-sh.sh` | verified | All 11 exited 0 with no `MODULE_NOT_FOUND`. |
| A guard with a missing script exits 2 and names it | Deleted `merge-guard.mjs` in the scratch project and ran its wired command from a subfolder | verified | Exit 2. Message: `guard-run: the hook script merge-guard.mjs is missing`. |
| Every case a guard blocks today stays blocked | Ran the unchanged guard suites, and a squash merge with `--admin` through the launcher from a subfolder | verified | Exit 2 with the `merge-guard` message. The em-dash-guard test gives the same exit code and output through the launcher as a direct run. |
| `env` holds `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` set to `1`, keeps other entries, and survives a rerun | Ran setup twice over a settings file with `FOO` set | verified | `1\|bar` after the first run. The second run left the file byte for byte equal. |
| `setup.ps1` writes the same settings | Ran `test-0000316-req-001-002-setup-ps1.ps1` through `pwsh` | verified | 12 of 12 passed. |
| Claude Code substitutes `${CLAUDE_PROJECT_DIR}` in a live session | Docs only. The checks above set the variable in the environment, which the docs say Claude Code also does | unverified (docs only) | The setup rerun check after this step runs every hook in a real session. |
