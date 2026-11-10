---
title: "Verification Report - 0000462-tests-without-git-identity"
summary: "What ran, and what it showed, for each acceptance criterion."
---
# Verification Report - 0000462-tests-without-git-identity

Method: ran the new suites, then reverted each PR #136 fix in a scratch copy of `ravintio-zero/` and ran the suites that cover it. No service started.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| AC-1 runners hide the git config | Ran `isolate_git_env` in a subshell with a developer `~/.gitconfig` and leaked author variables, then committed in a scratch repo | verified | A commit with no `-c user.email` exited 128. A commit with `-c user.name` and `-c user.email` exited 0. `test-0000462-req-001-git-identity-isolation.sh` passes 11 of 11 inside the isolation |
| AC-2 a commit with no identity fails locally | Reverted the identity flags of `commit_workspace_pack` in a scratch copy and ran `test-0000382-req-001-update-and-doctor.sh` under the isolation | verified | The suite failed on `setup exits 0` and the checks after it. With the developer identity in place, the same reverted copy passed those checks |
| AC-3 a BOM fixture runs against each first-line reader | Ran `test-0000462-req-002-bom-first-line-readers.sh` and the `.ps1` twin under `pwsh` | verified | The Bash suite passes 9 of 9 and the PowerShell suite passes 4 of 4. Before the `setup.sh` fix the Bash suite failed 1 of 9: `setup.sh` copied the pack `CLAUDE.md` to `original-CLAUDE.md` |
| AC-4 with the PR #136 fixes reverted, the local suite fails on both defects | Reverted both fixes in a scratch copy and ran the two suites | verified | Under the isolation the identity defect fails `test-0000382-req-001`. The BOM revert fails `doctor exits 0 on a boot file with a BOM` with and without the isolation |
