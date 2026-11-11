# Acceptance evidence - 0000481-regenerate-after-every-merge

- Checks: library audit, semantic correctness, consistency check, version check, backlog index check, archetype gates (none installed), and sync check passed. Self-corrections: 2 (prose-check sentence length in the standards text, edits moved from the installed copy to the source).
- Full suite in a clean clone: 408 suites passed, 2 failed. Both failures come from the clean clone, not from this step (`test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`). Both pass in the worktree at the base commit and at HEAD.
- Security: 0 critical, 0 high. Overall rating low. See `plan/current/security-report.md`.
- Execution: 4 criteria verified, 0 failed, 0 not-verifiable. See `plan/current/verification-report.md`.
- Docs edit pass: `prose-check.mjs check` exit 0 on 3 changed docs.
