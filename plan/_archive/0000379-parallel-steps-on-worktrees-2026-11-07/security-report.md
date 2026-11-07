# Security report - 0000379-parallel-steps-on-worktrees

Overall risk: low. No critical or high findings.

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| Step number reaches a path | `ravintio-zero/scripts/initiative-run.mjs` worktree and control paths | Low | Step numbers match `^[1-9][0-9]{0,2}$`. Feature ids match a fixed pattern before use in a branch name. |
| Symlinked worktree or control folder | `initiative-run.mjs` (`isLink` and `realpathSync` checks) | Low | The driver refuses a symlink and checks the real path stays under the root. |
| PR number from the `ready` file reaches the queue command | `initiative-run.mjs` queue call | Low | The driver validates digits only (`^[1-9][0-9]{0,6}$`) and passes an argument array. A test covers a bad value. |
| Copy of setup output into a worktree | `initiative-run.mjs` copy step | Low | The copy skips symlinks and does not dereference. |
| Watcher reads step folders | `ravintio-zero/scripts/initiative-watch.mjs` | Low | Same step pattern and symlink refusal. A test covers both. |
| Secrets | all changed files | none | No credentials found. No environment values logged. |

Risk register: R-001 to R-005 stay open with mitigations in place. No new dependencies.
