# Security report - 0000378-merge-time-versioning

Scope: `ravintio-zero/scripts/merge-queue.mjs`, `ravintio-zero/scripts/version-files.mjs`, and the changes to `ravintio-zero/scripts/reshape-initiative.mjs` and `check-initiative-history.mjs`.

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| Branch names from `gh pr view` reach `git` arguments with no leading-dash check | `merge-queue.mjs:228-285` | Low | Git rejects a ref name that starts with a dash, and the arguments use `refs/heads/` or `head:head` forms. Not mitigated in code. |
| `GH_BIN` and `GIT_BIN` environment variables choose the executables | `merge-queue.mjs:36-40` | Low | The variables exist for test shims and are set by the caller's own environment. Accepted. |
| Listed version file paths could leave the repo | `version-files.mjs` | Medium | Each path resolves under the root, including symlinks, and a test proves the refusal. Mitigated. |
| PR number or step from the command line reaches `gh` | `merge-queue.mjs:187` | Low | Both must match `^[0-9]+$`. Mitigated. |
| Shell injection through titles or paths | all four scripts | Low | Every call uses `execFileSync` or `spawnSync` with an argument array. Mitigated. |
| Force-push or history rewrite | `merge-queue.mjs:255,285,305` | Low | Pushes use plain `git push`. No force flag appears. Mitigated. |

## Credentials and data

No credential, token, or personal data appears in the changed files. The scripts print no environment values.

## Risk register cross-reference

- R-001 (shim differs from real `gh`): still open.
- R-002 (a fold hides a conflict): mitigated by the tree-equality and history check.
- R-003 (path or title reaches a shell or leaves the repo): mitigated.
- R-004 (queue and P4 both write a version): mitigated, the driver does not call the queue yet.

## Overall risk rating

Low. No critical or high findings. Top action before step 3 wires the driver: reject a ref name that starts with a dash.
