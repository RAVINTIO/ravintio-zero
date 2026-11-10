# Findings: postmortem rows (1, 2, 3, 4, 19, 20, 21)

> Source: research agent U1, saved by the orchestrator. Paths are relative to the repo root. `src/ravintio-zero/` is the pack source.

## Verdicts

| Row | Verdict | Open entry |
|-----|---------|------------|
| 1 | Partly addressed (PR #139 adds a decision row only). Root cause unaddressed. | 0000412 |
| 2 | Partly addressed (PR #139 adds prose). Enforcement gap unaddressed. | 0000412 |
| 3 | Unaddressed. | 0000413 |
| 4 | Partly addressed (PR #136 fixed two defects only). | 0000414 |
| 19 | Partly addressed (PR #147 landed the files). | none |
| 20 | Addressed by 0000420 (PR #151) for the stale entry. Partly addressed for the class. | none for the class, nearest is 0000419 |
| 21 | Unaddressed. | none |

## Row 1: ship archived `plan/current/` before CI passed

Evidence:
- `plan/postmortems/2026-11-08-archived-step-cannot-fix-ci.md`.
- `src/ravintio-zero/skills/ravintio-ship/SKILL.md` lines 62 to 69: Step 4 still archives with no CI wait first.
- `src/ravintio-zero/hooks/enforcement/gate-write.mjs` lines 360 to 364: blocks code writes when `plan/current/design.md` is absent.
- PR #139 adds decision rows to `initiative.md` and changes nothing else.
- `plan/backlog/0000412-ci-wait-before-archive/entry.md` (open).

5 whys:
1. The step blocked three times because it could not edit code to fix PR #136.
2. It could not edit because `gate-write` requires `plan/current/design.md` and the archive had removed it.
3. The archive ran first because the ship sequence archives before it raises the PR and waits for CI.
4. The chart field `Step CI fixes: allowed` assumed an editable run after the CI wait, and no check tested that against the ship order.
5. The roadmap standards and `ravintio-ship` define no reopen procedure for an archived run.

Verdict: partly addressed. Root cause unaddressed.

Widening: moving the archive after green CI needs none. A reopen procedure would widen `gate-write` to allow a code write when `plan/current/design.md` is absent but a matching `plan/_archive/{feature-id}-*/design.md` exists, or a restore marker exists. Prefer the first option.

## Row 2: the step wrote `ready` without watching CI

Evidence:
- The same postmortem, the 03:22:28 entry.
- `src/ravintio-zero/standards/roadmap-standards.md` lines 495 to 510: Step 4.2 already requires the CI watch before ready.
- PR #139 decision row "Write ready only after every check passes".
- Entry 0000412 wanted outcome.
- Not read: the step 6 session log. The finding relies on the postmortem quote.

5 whys:
1. The queue found the CI failure because the step wrote `ready` before CI finished.
2. The step wrote `ready` straight after `gh pr create` because the CI wait is a prose instruction.
3. A prose instruction has no check where the step writes `ready`, so skipping it costs nothing.
4. The driver treats a `ready` file as proof of green CI, and the file holds no CI evidence.
5. No check, hook, or driver step verifies PR checks before it accepts `ready`.

Verdict: partly addressed. PR #147 (0000411) makes the queue wait for checks before it merges. It does not stop an early `ready`.

Widening: none. A driver check on PR checks is stricter.

## Row 3: the driver missed a block in the final reply

Evidence:
- The same postmortem, 5 whys item 4.
- `src/ravintio-zero/scripts/initiative-run.mjs` line 194: `CONTINUE_PROMPT` still says "Read plan/current/build-log.md first".
- The same file, lines 400 to 416: `blockIn` accepts a prefix only before `Question:`. `Blocked:` must start the line. `openBlock` and `archivedBlock` read only the build log. No code reads the session result text.
- `plan/backlog/0000413-driver-reads-reply-blocks/entry.md` (open).

5 whys:
1. The driver resumed the session twice because it saw no block.
2. It saw none because it reads blocks only from the build log, and the step could not write the log.
3. The step reported the block in its final reply with an `I-D Advance:` prefix, and `blockIn` rejects a prefix before `Blocked:`.
4. The continue prompt names a file that no longer exists after the archive.
5. The block contract has no test against the reply forms that standards and skills tell steps to write.

Verdict: unaddressed. The code has not changed.

Widening: no guard widens. The driver would accept a short prefix and the result text, so it stops more often. The driver is not a fail-closed guard.

## Row 4: local tests passed, CI failed (git identity, BOM)

Evidence:
- The same postmortem, 5 whys item 5.
- `src/ravintio-zero/tests/helpers/assert.sh` line 305: `commit_workspace_pack` passes identity with `-c` (the PR #136 fix). No `GIT_CONFIG_GLOBAL` setting exists in `tests/helpers/*.sh`.
- `src/ravintio-zero/scripts/install-lifecycle.mjs` lines 177 to 178 strip the BOM (the PR #136 fix).
- `plan/backlog/0000414-tests-without-git-identity/entry.md` (open).
- Not checked: whether a BOM fixture exists.

5 whys:
1. CI failed two jobs because the runner has no global git identity and Windows PowerShell 5.1 writes a BOM.
2. The local run passed because the machine has a global identity and the run used `pwsh` only.
3. Test workspaces inherit the host git config, so results depend on the machine.
4. The suite has no mode that removes the global config and no fixture with a BOM.
5. The local P3 and pre-push checks have no step that compares the local environment with the CI runner.

Verdict: partly addressed. The check that would have caught both is absent.

Widening: none.

## Row 19: step 17 never landed the postmortem and its three entries

Evidence:
- `plan/.initiative-logs/step-17.log` line 28: the session ran `cat` on each queue item and got "Is a directory" for all eight. A grep found no later read of an `item.md`. The research did not read the whole log.
- `src/ravintio-zero/standards/roadmap-standards.md` lines 277 and 465: an item is a folder, and `item.md` holds the Step and Destination lines.
- Commit 9d69d99a lands the postmortem and entries 0000412 to 0000414. It reached main through PR #147 (commit 30e8907b).
- `plan/.initiative-queue/` now holds only `narrow-brand-guard-self-entry`.
- Not read: whether the cleared items named step 17.

5 whys:
1. The postmortem did not land in step 17's PR because the step never read the items' `item.md` files.
2. It never read them because its listing command treated each item as a file, and items are folders.
3. Nothing showed the step the item form where it listed the queue. The rule sits in one long standards paragraph.
4. The step ends with no check that every queue item that names it reached a commit or a report.
5. No driver or ship check compares the queue items that name a step with the step's merged diff.

Verdict: partly addressed. PR #147 landed the files. No change makes steps read folder items or checks for unconsumed items.

Open entry: none covers it. 0000413 covers the driver reply only.

Widening: none. A ship check on unconsumed queue items is stricter.

## Row 20: version list missed the source `component.yml`

Evidence:
- `plan/_archive/0000420-version-both-copies-2026-11-10/discovery.md`: `version-files.txt` lacked `src/ravintio-zero/component.yml`, so the queue's bump set the installed copy only. `validate-branch` failed at `sync-installed.mjs --check` (run 42725820833).
- PR #150 (0000397) moved the source and added the sync check to CI. It did not update the version list.
- PR #151 (commit 1693ad92, 0000420) adds an optional `? src/ravintio-zero/component.yml` line.
- `plan/_archive/0000420-version-both-copies-2026-11-10/build-log.md` line 36: a coordinator fix while the driver had stopped.

5 whys:
1. The queue's bump failed CI because it set the version in the installed `component.yml` and not in the source copy.
2. It set only one because `version-files.txt` named only the installed path.
3. The list lacked the new path because the layout move changed where a version file lives and did not update the list.
4. The move's tests asserted the exact shipped list (`test-0000378-req-001-version-files.sh`) and did not assert that the list names every version-carrying file.
5. No check ties the list of version files to the repo's real files.

Verdict: addressed by 0000420 (PR #151) for the stale entry. Partly addressed for the class. The step also patched the version by hand first, which hid the cause.

Open entry: none for the class check. The nearest is 0000419-layout-move-test-impact (open, not read in full).

Widening: none.

## Row 21: queue test fake missed the CI wait

Evidence:
- `plan/postmortems/2026-11-09-queue-test-fake-missed-ci-wait.md` (closed). Preventive and detective actions are both "none".
- Commit 805b3cd4 (step 16, PR #134) added `waitForChecks`. Commit 5e3a46f0 is the fake fix. The research opened neither.

5 whys:
1. The new suite did not finish because the queue waited for checks that the fake never reported.
2. The fake reported none because its author wrote it against the script as it stood before step 16 merged.
3. The plan took its source from an earlier read, not from the branch point.
4. Parallel steps change shared scripts within minutes, so an early read goes stale.
5. The plan standard has no step that rereads the files a unit edits at the branch point.

Verdict: unaddressed. No standard change or backlog entry covers the reread.

Widening: none.

## Missing evidence

- The research did not open commit 5e3a46f0, the PR #136 diff, or the step 6 logs. The findings use the postmortem quotes.
- The research did not read `step-17.log` in full.
- The research did not read entry 0000419 in full.
