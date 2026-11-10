# Instruction for step 21: CI gate and blocks until the postmortem fixes land

The human asked every step to follow these rules (2026-11-08). They apply until the fixes from `plan/postmortems/2026-11-08-archived-step-cannot-fix-ci.md` merge. Never weaken or skip an assertion to meet them.

1. **CI before ready.** After `gh pr create`, run `gh pr checks {pr} --watch --fail-fast`, as roadmap standards I-D Advance step 4.2 requires. Write `$RAVINTIO_INITIATIVE_CONTROL/ready` only after every check passes.
2. **CI fails after the archive.** If ship already archived `plan/current/`, take the restore route. The human approved it.
   1. Copy `design.md` and `build-log.md` from `plan/_archive/{feature-id}-{date}/` to `plan/current/`.
   2. Read the failing jobs with `gh run view {run} --log-failed`. Check git identity and the Windows PowerShell 5.1 BOM first.
   3. Fix the cause, log a `Rework:` line, commit, push, and watch CI to green.
   4. Archive the run again, then write `ready`.
3. **Blocks.** If you block, write the `Blocked:` line at the start of a line in the build log, with no phase prefix. The driver reads blocks only from the build log, so a block in your reply alone goes unseen. If `plan/current/` is gone, write it to the archived build log.

**Never merge your own PR.** Write `ready` and end your turn. The driver's merge queue merges the PR, bumps the version, and tags it. Step 12 merged PR #133 itself on 2026-11-08, so it has no version or tag, and the queue stopped on step 9.
