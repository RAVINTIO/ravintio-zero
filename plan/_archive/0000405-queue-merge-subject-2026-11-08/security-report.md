# Security report - 0000405-queue-merge-subject

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| None | `ravintio-zero/scripts/merge-queue.mjs` | none | The change passes a fixed subject to `git merge -m` as one argument with no shell. The subject holds 7 characters from the chart row and fixed text. The script never passes `--no-verify`, so the `commit-msg` hook still runs |
| None | `ravintio-zero/tests/test-0000405-req-001-short-base-merge-subject.sh` | none | The test works in a temporary folder with a local bare remote and a fake `gh`. It makes no network call |
| Credentials | all changed files | none | A scan of the diff found none |

**Overall risk:** low. No critical or high finding.

**Top actions before production.** None.
