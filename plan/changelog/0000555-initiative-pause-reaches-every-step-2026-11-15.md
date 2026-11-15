# Changelog (0000555-initiative-pause-reaches-every-step, 15 Nov 2026)

**Feature:** Initiative pause reaches every step
**Version:** set by the merge queue at merge
**PR:** #232

## What changed

- The new script `initiative-pause.mjs` has two commands. `request` writes `plan/.initiative-control/pause`. `write` writes `plan/current/pause.md` in each running step worktree and `plan/current-initiative/pause.md` in the root.
- The concurrent driver reads the request. It starts no step and queues no ready PR, and it stops each running session at its next `Complete: P{n}` build log line. It then writes the records, prints `I-C Run: Paused:`, releases the lock, and exits 0.
- A new driver that finds the initiative record prints `I-C Run: Resuming: initiative pause record read`. It removes the record and the request, and restarts each step in its worktree.
- Resume detection prints `initiative pause record present` before the step findings.
- The roadmap standards gain a pause section with rules `icpause-request`, `icpause-records`, and `icpause-resume`. The initiative skill gains one line.

## Why

When the human paused initiative 0000360 on 2026-11-12, the coordinator wrote each pause file by hand. The human ruled that a pause applies to each step and to the initiative.

## Deviations

- The plan named one standards rule. The standards hold three, one for each part of the pause.
- The driver passes `--merged` to the script, because the chart in the root can lag the initiative branch.
- The driver change stops the driver with a `Restart:` line after the merge. The coordinator starts a new driver.

## Validation results

- Three new suites pass: `test-0000555-req-001`, `test-0000555-req-002`, and `test-0000555-req-003`.
- The 58 suites that run the driver pass. One needed the pause note below its Summary text.

## Skipped phases

None.
