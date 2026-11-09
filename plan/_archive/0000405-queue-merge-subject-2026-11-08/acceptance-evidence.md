# Acceptance evidence - 0000405-queue-merge-subject

## Checks

- Suites: 329 of 331 passed.
- The two failures are `test-0000042-req-006` and `test-0000043-req-009`. They scan the step worktrees under `plan/.initiative-worktrees/` and pass in a clean clone of this branch.
- Self-corrections: 0.

## Security

No findings. See `security-report.md`.

## Execution

- The new suite fails before the fix. The hook rejects git's 148-character default subject.
- After the fix it passes 5 of 5 checks. The base merge commit reads `0000401: Merge the initiative branch`.
- The branch diff holds no change to a hook, `merge-guard`, `gate-write`, or `commit-standards.md`.
- Not verifiable: none.
