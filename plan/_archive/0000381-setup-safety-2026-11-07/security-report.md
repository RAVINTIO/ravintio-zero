---
title: "Security Report - 0000381-setup-safety"
summary: "Security review of the four setup changes."
---
# Security Report - 0000381-setup-safety

**Overall risk rating:** Low

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| Manifest paths drove `rm -rf` | `ravintio-zero/setup.sh` `remove_manifest_entries`, `ravintio-zero/setup.ps1` `Remove-ManifestEntries` | High before the change | Mitigated. A line must resolve to a direct child of the skills directory, with no `..` segment and no link. |
| Command prune could remove a developer file | `prune_retired_commands`, `Remove-RetiredCommands` | Low | Mitigated. The prune removes a plain file only, and the retired list needs the matching `name:` line. A manifest-listed file that the pack stopped shipping is removed. |
| Moved `CLAUDE.md` could overwrite an override | `preserve_developer_boot_file`, `Save-DeveloperBootFile` | Low | Mitigated. The destination is numbered when it exists, and a link at the destination folder stops the move. |
| Credentials | all changed files | None found | Not applicable |
| Dependencies | none added | None | Not applicable |

No guard gains an allowed form. The risk register entries R-001 to R-004 are mitigated by the tests named in the acceptance criteria.

Top action before release: run migration 0008 or setup in the main checkout, because its `.claude/commands/` still holds the retired files.
