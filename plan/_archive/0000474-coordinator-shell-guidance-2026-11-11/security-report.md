---
title: "Security Report - 0000474-coordinator-shell-guidance"
summary: "Security review of the queue drain and the bulk edit script."
status: "active"
version: "0.1.0"
---
# Security Report - 0000474-coordinator-shell-guidance

**Overall risk rating:** low

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| Deletion of the wrong folder | `src/ravintio-zero/scripts/initiative-queue.mjs` drain branch | Low | The drain removes only folders that `namedItems` returned. That function skips symlinks, checks the name against `NAME`, and requires a matching `**Step:**` line. |
| Path traversal in a spec | `src/ravintio-zero/scripts/bulk-edit.mjs` `check` | Low | The script rejects an absolute path, a `..` segment, a symlinked file, and a missing file before it writes anything. |
| Symlinked parent folder | `bulk-edit.mjs` `check` | Low | Not mitigated. The check covers the file itself, not each parent. The coordinator writes the spec and runs it, so the risk is accepted. |
| Replacement text read as a pattern | `bulk-edit.mjs` `replaceAll` | Low | The script uses `split` and `join`, so `$&` and `$'` stay plain text. A hand run confirmed it. |
| Credentials, dependencies, data exposure | none | none | The change adds no dependency, credential use, network call, or logging of file content. |

## Risk register cross-check

- R-001 (drain removes a running step's item): mitigated. The command takes one step number and the test leaves a step 8 item in place.
- R-002 (spec names a path outside the repository): mitigated for the file path. The parent-symlink case above stays open at Low.
- R-003 (skill passes its line cap): mitigated. Skill text stays under 1,720 lines.

## Top actions before production

None.
