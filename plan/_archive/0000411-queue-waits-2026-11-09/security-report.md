# Security report - 0000411-queue-waits

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| None | `ravintio-zero/scripts/merge-queue.mjs` | none | The change only adds waits and one retry. The queue still merges only after `waitForChecks` passes. Every `gh` call takes an argument array with no shell. The retry fires only on two named GitHub refusals |
| None | test fakes | none | The fakes run in temporary folders with local bare remotes. They make no network call |
| Credentials | all changed files | none | A scan of the diff found none |

**Overall risk:** low. No critical or high finding.

**Top actions before production.** None.
