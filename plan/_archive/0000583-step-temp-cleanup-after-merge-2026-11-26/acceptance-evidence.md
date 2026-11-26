# Acceptance evidence - 0000583-step-temp-cleanup-after-merge

## Checks

- Full suite in a clean clone of `HEAD`: 489 feature suites and 19 regression suites passed, 3 failed.
- The 3 failures are `test-0000450-req-004` (mirror tree path), `test-0000037-req-004` (clone has no `core.hooksPath`), and `test-0000318-req-004` (merge-guard diff against an old origin branch). The step changed none of these areas. The last two pass in the worktree.
- Self-correction cycles: 3. They covered the path limit in fixtures, seven pinned argument and environment suites, and the backlog index.
- Prose check on 4 changed docs: exit 0.

## Security

- No critical or high finding. S-001 (low) is open: no live session has confirmed the sandbox keys. See `plan/current/security-report.md`.

## Execution

- 20 acceptance criteria checked by running the driver against a stub claude and a real git repo. 19 verified.
- 1 not-verifiable: whether Claude Code honours the sandbox keys. See `plan/current/verification-report.md`.

## Scope change

- The human changed the scope on 2026-11-26. The agent removed `cleanStepTemp` before any suite ran. The build log records the deviations.
- The docs edit pass ran as a script check only. No fresh-context review ran.
