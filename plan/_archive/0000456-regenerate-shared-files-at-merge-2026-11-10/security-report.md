# Security report - 0000456-regenerate-shared-files-at-merge

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| Injection: git and gh calls | `shared-files.mjs`, `merge-queue.mjs`, `coordinator-pr-check.mjs` | Low | Every call takes an argument array. No shell runs. |
| Path traversal: resolver writes | `shared-files.mjs` `resolveSharedConflicts` | Low | It acts only on paths in `ALLOWLIST` and throws on any other conflicted path before it writes. |
| Untrusted file text | `shared-files.mjs` `resolveLivingDoc` | Low | The module reads text as data. A hunk that is not a `Last updated:` line or added table rows throws. |
| Argument injection: `--base` value | `coordinator-pr-check.mjs` `findOverlaps` | Low | The value follows the `--base` flag as one argument. |
| Credentials | all changed files | None | None read or written. |
| Dependencies | all changed files | None | Node built-ins only. |
| Silent wrong merge of a prose edit | `architecture-overview.md` | Low | Only `Last updated:` lines and table rows resolve. A prose conflict stops the queue. |

Overall risk rating: Low. No critical or high finding is open. The row dedupe and the stop mitigate the two risk register entries for a duplicate row and a prose conflict.
