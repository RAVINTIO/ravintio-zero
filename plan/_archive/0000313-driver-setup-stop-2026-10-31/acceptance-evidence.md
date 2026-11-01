## Acceptance evidence

**Checks**

- Full suite: 224 feature suites passed, 3 failed. The regression suite passed 19 of 19. Lint, typecheck, and build do not apply to this pack.
- The 3 failing suites are `test-0000042-req-006` (cites `plan/.initiative-logs/` step logs), `test-0000043-req-009` (runs the first), and `test-0000164-req-007` (the local generated `CLAUDE.md` lacks three phrases). The step logs and `CLAUDE.md` are ignored files outside this diff. Steps 2 and 3 of initiative 0000312 fix them. CI checks out a clean tree, so it is the first check of whether they pass there.
- New tests: 41 assertions in `test-0000313-req-001`, `-002`, and `-003`, all passing. `test-0000250-req-002` AC-3 now changes an unwatched path and passes.
- Self-corrections: 1. The old-name guard rejected two migration notes in the build log, and rewording them fixed it.

**Security**

- No critical or high finding. Two low findings, S-001 accepted and S-002 mitigated. See `plan/current/security-report.md`.

**Execution**

- Ran the real driver against a stub initiative. A skill change gave exit 1 and an `I-D Advance: Setup:` line. A restart file plus a hook file gave one `I-D Advance: Restart: Setup:` line. See `plan/current/verification-report.md`.
- Unverified (docs only): the live setup rerun by the initiative skill, because it needs the human session.

**Search evidence**

- No program was reported missing.
