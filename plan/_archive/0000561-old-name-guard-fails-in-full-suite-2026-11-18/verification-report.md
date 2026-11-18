# Verification Report - 0000561-old-name-guard-fails-in-full-suite

## What ran

The agent ran the guard suite and the full suite in a clean clone of the branch head. No service started.

## Criteria

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1: solo and full-suite results agree | CLI: ran `test-0000189-req-007-old-name-guard.sh` 15 times alone, then the full suite in a clean clone | verified | 15 of 15 solo runs passed. The full suite listed 3 inherited failures and no guard failure. |
| REQ-001 AC-2: the allowlist keeps its entries | Side effect: compared the suite diff | verified | The diff changes only the `allowed()` match and adds cases. `ALLOW_DIRS`, `ALLOW_FILES`, and `OLD_NAMES` hold the same entries. |
| REQ-002 AC-1: the planted change passes | CLI: ran the suite with a shim `grep` that exits 2 | verified | RED before the fix, GREEN after, in the build log. The suite reports 8 passed, 0 failed. |
| REQ-002 AC-2: a planted old name still fails | CLI: same suite | verified | The case passes and the guard names `ravintio-zero/skills/demo/SKILL.md:2`. |

## Not verifiable

The flaky failure itself depends on machine load and does not reproduce on demand. The full-suite runs of this step show no guard failure. Earlier logs of steps 4, 30, 47, and 51 show it.
