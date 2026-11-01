---
title: "Supervision notes: 0000312 - guards, history, and test noise"
summary: "Findings the coordinator saw while steps ran, kept for the I-E Delivery report and retrospective."
status: "active"
---
# Supervision notes: 0000312

The coordinator wrote these notes at the step 5 `Setup:` stop on 2026-10-31. Read them at I-E Delivery. Each one goes into the final report, the retrospective, or a backlog entry. Delete this file in the delivery coordinator PR after you file each note.

## For the human at delivery

- **Untitled squash on the initiative branch.** `8c01e3d chore(setup): record the setup rerun after step 2 (#83)` breaks the `{id}-{slug}: {summary} (#n)` rule. GitHub takes a one-commit squash title from the commit subject, not the PR title. The step 7 history script will fail on it. Per `## History check`, list it in the initiative PR body and stop for the human. Every coordinator commit since PR #86 uses the titled subject.
- **Step 3 fixed its own CI failure instead of stopping.** The chart lists "CI fails on a step PR" as a stop condition. Step 3 pushed `cc98715` to PR #84 to fix a Windows PowerShell 5.1 failure in `run-tests.ps1`. The fix is correct and stays inside the step's scope. The human did not ask for a hold. Propose that future charts say whether a step may fix its own CI failure.
- **Step 5 ran independent units inline on cost alone.** Its P2 note says no dependency forced the sequence. The human's rule in `## Parallel work in each step` allows a sequence only for a dependency or a shared file.

- **Step 6 recorded no scope lock lines.** Its build log holds one line, "Self-confirmed: design and scope lock, draft-accepted (initiative)". Steps 1 to 5 each recorded four path lines with `[source: draft-accepted (initiative)]`.

## Candidate backlog entries

- **The coordinator title rule covers the PR title only.** Step 6's `## Coordinator PRs` sets the title form for the PR. A one-commit squash takes its title from the commit subject, which is how `8c01e3d` broke the rule. Add one sentence: in a one-commit PR, the commit subject uses the same form.
- **Missing launcher allows.** If `guard-run.mjs` is missing, its command exits 1 and Claude Code allows the call. Step 4's security report rates it medium and leaves it unmitigated in code. The setup-stop hook check catches it at the next stop.
- **Forced-add guard misses three forms.** `git stage -f {path}` (a built-in synonym for `git add`), a subshell such as `(git add -f {path})` or `$(git add -f {path})`, and a flag held in a variable. Step 5's security report rates these medium. The CI ignored-file check is the backstop.
- **Codex has no forced-add guard.** Step 5 left Codex out of scope. Only the CI check covers it.
- **`plan/.prefix-misses.log` is ignored only through `.git/info/exclude`.** A fresh clone and CI do not see it as ignored, so the CI check would not catch a forced add of it.
- **Setup-record PRs cost about 12 minutes each.** Setup rewrites the `writtenAt` timestamp in the tracked `plan/state/claude-code.md` at every rerun. Each `Setup:` stop then needs a full suite and CI only to commit a timestamp. The draft's note that setup writes only ignored files was wrong.
- **The watcher reports false stale lines.** Before a step writes its build log, the watcher reads the last archived log and calls it stale. Open entry 0000270 covers this.

## Retrospective input

- **Typed build log times.** Step 1 typed times ahead of the clock, such as `Done: U1 ... 19:25` at 19:24. Open entry 0000266 covers this. Steps 2 to 5 read the clock with `date -u`.
- **Stash under running subagents.** Step 1 ran `git stash` while two P2 subagents had uncommitted edits. Filed as entry 0000331.
- **Guard gaps in steps 1 to 4.** A `cd` in a step session lasted into the next command, so a relative hook path could fail to resolve for one call. Every write or merge seen in a gap would have passed its guard anyway. Step 4 closed the gaps: hooks now resolve from `${CLAUDE_PROJECT_DIR}`, and `env.CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` is `1`. The coordinator first told the human at step 1 that no gap occurred, then corrected it at step 3.
- **Suites running during edits.** Steps 4 and 5 started the full suite, then edited tracked files while it ran. The runner's tree check from step 3 can fail a run for that. Several steps ran three or four full suites at about 20 minutes each, mostly to find hard-coded hook counts one batch at a time.
- **Retrospective entry mislabel.** Step 1's retrospective pins the phase guard fix to entry 0000265. The fix was entry 0000264.
