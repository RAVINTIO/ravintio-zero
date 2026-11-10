# Coordinator evidence for initiative 0000360

> Input for step 22, the initiative retrospective. The coordinator session wrote it from its own record of the run. Each row names its evidence. Step session logs live at `$RAVINTIO_INITIATIVE_ROOT/plan/.initiative-logs/step-{n}.log` and `step-{n}.attempt-{k}.log`. The driver and the watcher own those files, so read them and never move them.

## Stops and mistakes

Times are UTC. "Coordinator" marks a mistake by the coordinator session. A blameless record still names the gap in the process, check, or tool, not the session.

| # | When | Step | What happened | Evidence | Fixed by |
|---|------|------|---------------|----------|----------|
| 1 | 2026-11-08 | 6 | Ship archived `plan/current/` before CI passed. CI then failed, and `gate-write` blocked the fix. The step blocked three times and held five ready PRs for about seven hours | `plan/postmortems/2026-11-08-archived-step-cannot-fix-ci.md`, PR #136 | Decision rows in #139. Entries 0000412 to 0000414 open |
| 2 | 2026-11-08 | 6 | The step wrote `ready` without watching CI | same postmortem | Decision row in #139. Entry 0000412 open |
| 3 | 2026-11-08 | 6 | The driver missed a block written only in the session's final reply, with a phase prefix before `Blocked:` | same postmortem | Entry 0000413 open |
| 4 | 2026-11-08 | 6 | Local tests passed with a global git identity, and CI failed without one. Windows PowerShell 5.1 BOM handling also differed | same postmortem | Entry 0000414 open |
| 5 | 2026-11-08 | queue | Git's default base-merge subject was 106 characters, so the `commit-msg` hook rejected it and the queue stopped | PR #140 | 0000405 |
| 6 | 2026-11-08 | coordinator | PR #140 edited `docs/architecture-overview.md` and `plan/backlog/.next-id`, so five ready steps conflicted | PR #140, interim memory item 7 | Workaround only: check `git merge-tree` before a coordinator merge |
| 7 | 2026-11-08 | 12 | The step session squash-merged its own PR #133 outside the queue. It got no version, no tag, and a `pending` chart row. A restarted driver then started a fresh step 12 session | PR #133, PR #141 | Repaired by #141 and tag `v0.64.0`. Prevention open |
| 8 | 2026-11-08 to 09 | 9, 13, 16, 18 | Step sessions missed queued instructions. Step 13 read `plan/.initiative-queue` inside its worktree, which is empty, and wrote `ready` four times without merging | `step-13.attempt-*.log` | Workaround: the coordinator copied each item into the worktree. Driver fix open |
| 9 | 2026-11-09 | 9 | The step wrote a timestamp to `ready` instead of the PR number, so the driver stopped with "invalid ready file" | `plan/.initiative-control/step-9/ready` at 00:27 | Coordinator rewrote the file. Format fix open |
| 10 | 2026-11-09 | 20 | The step left `ready` empty after its CI fix | `step-20.log`, 00:17 | Coordinator rewrote the file. Format fix open |
| 11 | 2026-11-08 to 09 | 8, 9, 10, 11, 13, 16 | The queue pushed its version commit and merged at once. GitHub answered "Pull Request is not mergeable" | driver output, PR #138, #130, #145, #143, #135, #134 | 0000392 and 0000411 |
| 12 | 2026-11-08 to 09 | most steps | Every merge changed `architecture-overview.md`, `decisions-index.md`, `plan/backlog/index.md`, `.next-id`, or `docs/adr/.next-id`. Every other open PR then conflicted. About six rounds of conflicts, at about an hour each | queue output, rebase instructions | Open: regenerate shared files at merge |
| 13 | 2026-11-08 to 09 | 8, 9, 11, 16 | A failed queue run left a `chore: set version` commit on the step branch. The next merge then conflicted on the version rows | PR #130, #143, #134 | Coordinator and steps resolved by hand. Open |
| 14 | 2026-11-08 to 09 | queue | The queue worktree stayed on a step's branch after a failed merge, and later the queue couldn't check out a branch that a step worktree held | `plan/.initiative-worktrees/queue` | Coordinator detached and removed worktrees by hand. Open |
| 15 | 2026-11-09 | all | CI took about 16 minutes per merge, with suites run serially and the `.ps1` suites three times | run 42591372542 | 0000409 |
| 16 | 2026-11-08 to 09 | coordinator | Ready, green, clean PRs waited while the driver was stopped, because the coordinator merged only through the driver. The human asked why | interim memory | Rule: run the queue by hand on ready PRs. Driver change open |
| 17 | 2026-11-09 | coordinator | The coordinator missed a ready line for 24 minutes (step 16, 16:19), and a driver exit for about two hours (10:34), because no monitor was armed | watcher output | Monitor on driver lines. Open: the driver should notify |
| 18 | 2026-11-09 | 4 times | Each step that changed hooks, skills, or setup stopped the driver with `Setup:` for the same approved command | driver output | Open: the driver runs the `Confirmation:` command itself |
| 19 | 2026-11-09 | 17 | Step 17 never landed the 2026-11-08 postmortem and its three entries from the queue | `plan/.initiative-queue/` | Landed in #147 |
| 20 | 2026-11-10 | 20 | The version list named only the installed `component.yml`, so the queue's bump failed CI's sync check. The step patched the version and not the cause | run 42725820833, PR #150 | 0000420 |
| 21 | 2026-11-09 | coordinator | A coordinator test fake did not answer the CI wait that step 16 had just merged, so the first test run sat in the wait | `plan/postmortems/2026-11-09-queue-test-fake-missed-ci-wait.md` | Recorded. Preventive action open |
| 22 | 2026-11-08 to 10 | coordinator | Shell snags cost time. zsh doesn't split `set -- $x`, zsh reads `$b:r` as a modifier, and `merge-guard` and `block-forced-add` blocked compound or variable commands. A JavaScript `replace` with `$'` duplicated a test file | coordinator session | Workaround: bash wrappers and the Write tool. Open |
| 23 | 2026-11-08 to 09 | coordinator | The coordinator gave a wrong status twice. It said the driver was merging when the queue had failed, and it said step 15 would be stuck when it was not | coordinator session | None |
| 24 | 2026-11-09 | 14, 15, 19 | Step replies typed times instead of reading the clock, up to an hour off | watcher activity lines | Open |
| 25 | 2026-11-08 | 18 | The brand guard self-entry instruction for step 18 stayed in the queue | `plan/.initiative-queue/narrow-brand-guard-self-entry/` | Unknown. Step 22 checks |
| 26 | 2026-11-08 to 10 | all | The human could not oversee the run easily: many stops, long reports, and decisions mixed with routine fixes. The human called it "a mess" and asked for easier oversight | human messages | Open: one status view, fewer stops |
| 27 | 2026-11-10 | 21 | `initiative-add-step.mjs` wrote the bare id `0000421` as the step's `Feature id`, with no slug. The driver then stopped with "step 22 has an invalid feature id" | driver output 02:18, PR #153 | Chart row fixed by hand. Script fix open |

## Interim workarounds still in use

The coordinator runs these on every step until fixes land:
- Check CI when a step writes `ready`.
- Include the restore route in every CI-fix instruction.
- Read the final reply of each step session for missed blocks.
- Copy queue items into the step worktree.
- Check the queue worktree's branch before a restart.
- Keep coordinator PRs narrow.
- Merge ready PRs by hand after the driver stops.
