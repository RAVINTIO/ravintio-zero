# Acceptance evidence - 0000505-coordinator-branch-regenerate

- Checks: semantic correctness, consistency check, version check, backlog index check, prose check, archetype gates (none installed), and sync check passed. Self-corrections: 1 (the plan gate allowed 3 criteria, so I moved the dirty-tree case out of the acceptance list).
- Full suite in a clean clone, 4 shards: 417 suites passed, 2 failed. Both failures come from the clean clone, not from this step (`test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`). The same 2 fail in the baseline. The worktree run passed all 419 suites.
- Security: 0 critical, 0 high. Overall rating low. See `plan/current/security-report.md`.
- Execution: 3 criteria verified, 0 failed, 0 not-verifiable. See `plan/current/verification-report.md`.
- Docs edit pass: `prose-check.mjs check` exit 0 on the whole repo.
