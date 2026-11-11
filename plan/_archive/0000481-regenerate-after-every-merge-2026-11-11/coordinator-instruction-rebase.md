# Instruction for step 42: merge the initiative branch into PR #177

PR #177 conflicts with `initiative/0000360-backlog-sweep` at `4b19f29a`. Git reports conflicts in these files:

- `docs/architecture-overview.md`
- `docs/decisions-index.md`
- `plan/.feature-id`
- `plan/backlog/index.md`
- `ravintio-zero/scripts/merge-queue.mjs`
- `src/ravintio-zero/scripts/merge-queue.mjs`

Step 44 (0000485) merged first. It added `renumberIds` to `merge-queue.mjs` at the same places where this step adds `regenerateAfterMerge`. Keep both. Run the renumber first and the regeneration after it, because a renumber changes the backlog folders that the index lists.

Your run has no archive yet, so `plan/current/` is still in place. The human approved this route.

1. Add a `Resolved:` line to the build log for the earlier block. The cause was the conflict, not the CI triggers.
2. Pull `origin/feat/0000481-regenerate-after-every-merge` first, because the coordinator pushed merge commit `a1e8ac3` to it. Then fetch and merge `origin/initiative/0000360-backlog-sweep` into `feat/0000481-regenerate-after-every-merge`.
3. In `merge-queue.mjs`, keep both features in both copies, `src/ravintio-zero/` and `ravintio-zero/`. Keep both doc comments and both imports.
4. For the `Last updated` lines and `plan/.feature-id`, keep this branch's value. Regenerate `plan/backlog/index.md` with `node ravintio-zero/scripts/backlog-index.mjs`. Rebuild `docs/decisions-index.md` so each step's rows appear once.
5. Add a test that runs a base merge which both renumbers an id and regenerates the index.
6. Run the full suite on a clean tree. Log a `Rework:` line in the build log, commit the merge, and push.
7. Run `gh pr checks 177 --watch --fail-fast`. Continue only after every check passes.
8. Archive the run, push, and watch CI to green once more. Then write `ready`.
9. If you block, write the `Blocked:` line at the start of a line in the build log, with no phase prefix.
