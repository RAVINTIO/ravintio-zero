# Acceptance evidence - 0000507-hook-check-after-setup

## Checks

- Clean-clone suite run: 445 passed, 3 failed, plus 19 of 19 regression suites. The 3 failures fail on the base commit too and sit in the baseline file as inherited: `test-0000037-req-004`, `test-0000318-req-004`, and `test-0000450-req-004`. The baseline check exits 0.
- The clone ran before the launcher-line fix. The agent reran the two new suites and `test-0000321-req-005` after the fix, and all pass.
- A first working-tree run found a stale backlog index. The agent fixed it.
- New suites: `test-0000507-req-001-hook-check.sh` 29 checks, `test-0000507-req-003-driver-hook-check.sh` 15 checks. Both pass.
- Driver suites 0000448, 0000313, and 0000250 pass.
- `consistency-check.mjs` and `prose-check.mjs` are clean. `archetype-gates.mjs` found no gates installed.
- Self-correction cycles: 1 (launcher failure rule, REQ-002).

## Security

- 0 critical, 0 high, 0 medium. 3 low findings and 1 informational finding, all accepted or mitigated. See `plan/current/security-report.md`.

## Execution

- 9 of 9 criteria verified. 0 not-verifiable. See `plan/current/verification-report.md`.
- Search evidence: no report names a missing program.

## Docs edit pass

- Changed docs: `docs/architecture-overview.md`, `docs/decisions-index.md`, `docs/component-registry.md`, `docs/dependency-graph.md`, `src/ravintio-zero/docs/hook-check.md`, `plan/changelog/0000507-hook-check-after-setup-2026-11-12.md`.
- Cycles: 1 (no edit needed). `prose-check.mjs` exit code: 0.
