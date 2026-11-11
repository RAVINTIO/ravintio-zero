# Changelog (0000519-ship-removal-needs-human-approval, 11 Nov 2026)

**Feature:** Ship removal needs human approval
**Version:** set by the merge queue at merge
**PR:** 187

## What changed

- Ship Step 4 removes `plan/current/` with `git rm -r -q plan/current` after the copy. The path is literal, with no `cd` and no glob.
- Rule `implement-full-suite-once` tells the agent to write docs before the full suite starts and to change no file until it ends. The fast batch line for docs units says the same.
- Two new suites, `test-0000519-req-001-ship-removal-command.sh` and `test-0000519-req-002-p2-docs-timing.sh`, cover the text.
- ADR 0320 records the decision.

## Why

On 2026-11-11 the Claude Code safety check refused the plain delete in ship Step 4. Step 57 stopped for about two hours until the coordinator ran `git rm -rq plan/current`. P2 also told the agent to write docs while the suite ran, and the runner fails on a changed tree.

## Deviations

- P2 ran inline without subagents, because the two units are small and edit separate files.
- The `.claude/skills/` copies refresh at the next setup run.

## Validation results

- Each new suite failed before its change and passes after it.
- The full suite result is in the verification report.

## Skipped phases

None.
