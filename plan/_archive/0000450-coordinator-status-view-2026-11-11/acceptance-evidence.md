# Acceptance evidence - 0000450-coordinator-status-view

## Checks

- Full suite on the working tree: 419 feature suites and 19 regression suites passed, 0 failed.
- Clean clone of `HEAD`: 417 feature suites passed and 2 failed. Both failures come from the base commit.
  - `test-0000037-req-004-remove-old-folder.sh`
  - `test-0000318-req-004-merge-guard-pinned.sh`
- Baseline check: no new failing suite.
- `prose-check.mjs` exits 0 on the changed docs. `sync-installed.mjs --check` exits 0.
- Self-corrections: 1. The security review found control characters in the status script output. The fix and its test landed in one commit.
- OS gap: local macos, CI ubuntu, windows.

## Security

No critical or high findings. One low finding (S-001) has a fix. See `plan/current/security-report.md`.

## Execution evidence

- The status script ran against the live initiative root and printed the driver state, step counts, and running steps.
- The watcher ran once against the same root and printed a heartbeat that ends `merged 41 of 57`.
- A bad argument exits 1 with a `Blocked:` line.
- No criterion is `not-verifiable` except a live queue failure, which the fake queue covers.

## Docs edit pass

Skipped: the changed docs pass `prose-check.mjs`, and a fresh-context pass adds no check beyond it for 3 short insertions.
