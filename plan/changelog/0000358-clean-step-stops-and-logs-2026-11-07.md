# Changelog (0000358-clean-step-stops-and-logs, 07 Nov 2026)

**Feature:** Clean step stops and logs
**Version:** 0.55.0
**PR:** pending

## What changed

- The status set gains `Question`. The orchestrator skill, `pipeline-reference.md`, both boot templates, and the comment in `check-reply-prefix.mjs` list it. `Question:` asks a routine question. `Blocked:` marks an exception stop only. The product id check now asks with `Question:`.
- The orchestrator, plan, implement, validate-and-accept, and ship skills tell the phase to read every logged time with `date -u +%Y-%m-%dT%H:%M:%SZ`. The phase invocation reference also asks for a `Complete: P<n>` line when a block closes.
- `build-log-check.mjs` fails a time later than the commit that adds its line, and a closed phase block with no `Complete:` or `Skipped:` line.
- `run-tests.sh` and `run-tests.ps1` print `Failed suites:` and each failed suite's file name under the totals, in quiet mode too. The validate skill points at the list.
- Backlog entries 0000273, 0000266, 0000335, and 0000269 are pulled in and deleted.

## Why

Agents wrote `Blocked:` for routine questions, which inflates the counts that governance and resume detection read. Step build logs carried guessed future times and phase blocks with no end line. A failed test run showed only totals, so naming each failure took repeated 5-minute runs.

## Deviations

- Units ran inline, not as subagents.
- `CLAUDE.md` is generated from the boot template and ignored by git. The change lands in the two boot templates, and the local copy was edited by hand.
- The time check compares with the clock when git cannot report a line's commit.
- `test-0000151-req-011` pinned the old status line, the product id line, and hard limit 9. It now rewrites the first two in its base fixture, and the clock rule is a new paragraph.
- `test-0000248-req-002` fixtures now close each block with a `Complete:` line.

## Validation results

- The full suite passes: 284 feature suites and 19 regression suites. The PowerShell suites pass under `pwsh`. The consistency check passes.
- 6 criteria verified by execution. 0 failed. 1 not-verifiable here: the hook and setup check after the setup rerun, which the coordinator runs.
- Security review found no critical, high, or medium findings.

## Skipped phases

None.
