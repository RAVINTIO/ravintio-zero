# Verification Report - 0000450-coordinator-status-view

**Feature:** 0000450-coordinator-status-view

## What ran

The status script and the watcher ran against the live initiative root (`--root $RAVINTIO_INITIATIVE_ROOT`) while the driver held the lock. The driver change ran through the `scheduler-fixture.sh` fake queue.

## Criteria

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| AC-1 status lists each step state | CLI run on the live root | verified | Printed `driver running`, `merged 41, ready 0, running 3, pending 13 of 57`, and a line for each running step |
| AC-2 a merged step shows no stop | Suite fixture with a queue stop for a merged step | verified | Printed `no live stops` |
| AC-3 a live stop shows its text | Suite fixture with an open `Blocked:` line | verified | Printed `stop step {n}` with the text, control characters removed |
| Bad argument | CLI run with `--bogus` | verified | Exit 1 and `I-C Run: Blocked: bad argument: --bogus` |
| Watcher ready event | Suite, two polls with a new `ready` file | verified | One `event: step {n} ready PR #{k}` line |
| Watcher merged step | Suite, stale `ready` file for a merged step | verified | No ready event and no ready heartbeat |
| Watcher driver exit | Suite, lock removed between polls | verified | One `event: driver exited` line |
| Watcher heartbeat | CLI run on the live root | verified | Each heartbeat ends `merged 41 of 57` |
| Driver prints the queue failure | Suite with `QUEUE_FAIL_STEP=1` | verified | The line prints before `I-C Run: Stopping:` and again at exit |
| Driver logs the queue failure | Same suite | verified | The last line of `step-1.log` is the same line |
| Skill and standards text | Suite grep | verified | Names the status script, both report parts, and `driver exited` |
| Status script under 2 seconds on 60 steps | Timed suite case | verified | Under 2 seconds |

## Not verifiable

- The driver line in a live queue failure. No real queue failed during this step, so the fake queue stands in for it.
