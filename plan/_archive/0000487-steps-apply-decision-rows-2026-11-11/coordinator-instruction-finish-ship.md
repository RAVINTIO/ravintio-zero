# Instruction for step 45: finish P4 Ship for PR #179

Your last session stopped because the Claude Code safety check refused the removal of `plan/current/`. The human approved the removal. The coordinator ran `git rm -rq plan/current` in your worktree on 2026-11-11. The 17 deletions are staged, and nothing is committed yet. The archive folder `plan/_archive/0000487-steps-apply-decision-rows-2026-11-11/` is still untracked.

1. Check that the archive holds every file that `plan/current/` held. Copy the last lines of the old build log into the archived build log if they differ. Recover them with `git show HEAD:plan/current/build-log.md`.
2. Add a `Resolved:` line to the archived build log for the block.
3. Stage the archive folder by its literal path and commit the archive move.
4. Finish the work your last session listed:
   - Append the CI duration line to the archived build log (417s, run 42957194743).
   - Write `build-report.md` and the retrospective.
   - File one backlog entry. P2 tells you to write docs while the full suite runs, but the runner fails on a changed tree.
   - Clear the sentinels, make the closing push, and wait for CI.
5. Merge `origin/initiative/0000360-backlog-sweep` first if PR #179 conflicts. Steps 29, 42, and 54 merged after your PR opened.
6. Run `gh pr checks 179 --watch --fail-fast`. Write `ready` only after every check passes.
7. If you block, write the `Blocked:` line at the start of a line in the build log, with no phase prefix.
