# Acceptance evidence - 0000456-regenerate-shared-files-at-merge

## Checks

- Full suite in a clean clone of `HEAD`: 389 feature suites and 19 regression suites passed. 2 feature suites failed.
- Both failures fail on the base commit too: `test-0000037-req-004-remove-old-folder.sh` and `test-0000318-req-004-merge-guard-pinned.sh`. `baseline-failures.mjs check` reported no new suite.
- The 3 new suites for this step passed: 11, 15, and 10 checks.
- `sync-installed.mjs --check`, `prose-check.mjs` on the changed docs, `archetype-gates.mjs`, and `consistency-check.mjs` all exited 0.
- Self-corrections in P3: 0.
- The clean-clone run printed `OS gap: local macos, CI ubuntu, windows`.

## Security

No critical, high, or medium finding. Overall rating: Low. See `plan/current/security-report.md`.

## Execution evidence

I ran `resolveSharedConflicts` on a real conflicted `git merge` in a throwaway repo. Both `.next-id` files kept the higher value. Both living docs kept the PR side's `Last updated:` line and the rows from both sides. A conflict in `other.txt` threw and left the merge for the abort. The overlap check, run against a stub `gh`, printed `overlap: #7 other.txt` and exited 1. It ignored a `chore/` PR and the queue-owned index file. No criterion is `not-verifiable`. See `plan/current/verification-report.md`.

## Docs edit pass

Changed docs: `docs/architecture-overview.md`, `docs/decisions-index.md`, `docs/adr/0302-queue-resolves-shared-file-conflicts.md`, and `roadmap-standards.md`. Cycles: 0. Final `prose-check.mjs` exit code: 0.
