# Security report - 0000454-queue-failure-recovery

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| None | `src/ravintio-zero/scripts/merge-queue.mjs` `revertStaleVersionCommits` | none | Every git call takes an argument array and no shell runs. The commit shas come from `git log`. The two regular expressions embed only the first 7 characters of the chart feature id and the step number, which `requireInt` limits to digits |
| None | `src/ravintio-zero/scripts/merge-queue.mjs` detach | none | `git switch --detach` takes no user input and its failure is ignored by design |
| History | `src/ravintio-zero/scripts/merge-queue.mjs` | none | The queue pushes the revert commit without force. The new suite checks that the old PR head stays in the branch history |
| Credentials | all changed files | none | A scan of the diff found none |

**Overall risk:** low. No critical or high finding.

**Top actions before production.** None.
