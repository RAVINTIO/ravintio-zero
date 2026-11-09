# Verification report - 0000390-prose-checks

## What ran

I ran the linter and the Stop hook from this worktree against a scratch folder with one 26-word doc. I also ran the new suites and the full suite in a clean clone.

## Criteria

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| A 26-word sentence in `docs/` fails with file and line | CLI | verified | `check --files docs/x.md` printed `docs/x.md:1 sentence-length: 26 words` and exited 1 |
| A code block sentence passes | CLI via suite | verified | `test-0000390-req-001-prose-rules.sh` passes 16 assertions |
| A baselined breach passes until fixed | CLI via suite | verified | `test-0000390-req-002-baseline-ratchet.sh` passes 22 assertions |
| A raised baseline fails | CLI via suite | verified | `diff --base HEAD` exits 1 and names the file and rule |
| `commit-msg` and pre-commit block, CI runs both commands | Hook trigger | verified | `test-0000390-req-003-enforcement-points.sh` passes 15 assertions. Two commits in this run showed the hook blocking a real breach. |
| The validate skill names the edit pass | File read | unverified (docs only) | The edit pass is skill text. No run observed a subagent edit. The test checks the text. |
| A 30-word reply makes a note and exit 0 | Hook trigger | verified | The hook printed a `systemMessage` that quotes the first 40 characters, and bad JSON exited 0 |
| Both setup scripts register the hook | File read | unverified (docs only) | The suites read `setup.ps1` from source. No PowerShell install ran the hook wiring. |
