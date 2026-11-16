# Acceptance evidence - 0000551-refuse-symlink-style-outputs

- Checks: the clean-clone suite shows 475 feature suites passed and 3 failed, with 19 regression suites passed. All 3 failures also fail on the base commit.
- New suites: `test-0000551-req-001-002-setup-sh.sh` passes 20 checks. The PowerShell suite passes 16.
- Self-corrections: 0 cycles.
- Security: 0 critical or high findings. Overall risk is low. Finding S-001 (boot file write follows a link) stays open. The brief defers it.
- Execution: 5 of 5 criteria verified by running `setup.sh` with planted links.
- Docs edit pass: changed docs are `docs/architecture-overview.md` and the changelog. `prose-check.mjs` exits 0. The agent ran the pass inline, not as a subagent.
- Archetype gates: none installed.
- Inherited failures: `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, `test-0000450-req-004-report-format.sh`.
