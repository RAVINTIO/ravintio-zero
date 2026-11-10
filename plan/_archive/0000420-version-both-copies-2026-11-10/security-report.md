# Security report - 0000420-version-both-copies

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| None | `src/ravintio-zero/scripts/version-files.mjs` | none | `resolveInRoot` checks every path, optional or not, before any read or write. A test covers an optional path outside the root |
| None | `src/ravintio-zero/scripts/merge-queue.mjs` | none | The queue stages a fixed list of existing files with an argument array. No shell runs |
| Credentials | all changed files | none | A scan of the diff found none |

**Overall risk:** low. No critical or high finding.

**Top actions before production.** None.
