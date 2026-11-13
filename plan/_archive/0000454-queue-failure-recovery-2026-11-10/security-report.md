# Security report - 0000454-queue-failure-recovery

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| Regular expression injection (CodeQL, 4 alerts) | `src/ravintio-zero/scripts/merge-queue.mjs` `activeVersionCommits` | high as scored, low in fact | The first draft built two patterns from the chart feature id and the step number. `requireInt` limits the step to digits, but CodeQL could not see that. The fix uses two fixed patterns and compares the captured id and step. No input builds a pattern now |
| None | `src/ravintio-zero/scripts/merge-queue.mjs` `revertStaleVersionCommits` | none | Every git call takes an argument array and no shell runs. The commit shas come from `git log` |
| None | `src/ravintio-zero/scripts/merge-queue.mjs` detach | none | `git switch --detach` takes no user input and its failure is ignored by design |
| History | `src/ravintio-zero/scripts/merge-queue.mjs` | none | The queue pushes the revert commit without force. The new suite checks that the old PR head stays in the branch history |
| Credentials | all changed files | none | A scan of the diff found none |

**Overall risk:** low. No critical or high finding.

**Top actions before production.** None.
