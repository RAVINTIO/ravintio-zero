# Verification report - 0000456-regenerate-shared-files-at-merge

I ran the resolver and the overlap check against throwaway git repos. I tore each repo down afterwards.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| Counter files take the higher value | Real conflicted `git merge`, then `resolveSharedConflicts` | verified | `plan/backlog/.next-id` and `docs/adr/.next-id` read 12 and 7, the higher side in each case |
| Index files resolve | Same merge, conflicts on both living docs | verified | `Last updated:` kept the PR side. The table held the base row and the PR row |
| Backlog index is regenerated | `test-0000456-req-001-queue-resolves.sh` runs the queue against a conflicted `plan/backlog/index.md` | verified | 10 of 10 checks passed |
| Other conflicts still stop | Conflict in `other.txt` | verified | The call threw `conflict in other.txt, which the queue does not resolve`. The file stayed unmerged until the abort |
| Overlap check names open step PRs | Stub `gh` listing two PRs, run with `--base` | verified | Printed `overlap: #7 other.txt`, exit 1. The `chore/` PR and the queue-owned index file gave no line |
