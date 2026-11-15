# Acceptance evidence - 0000549-baseline-record-checks

## Checks

| Check | Result |
|-------|--------|
| Semantic correctness | REQ-001 and REQ-002 each have an executing test in `ravintio-zero/tests/test-0000385-req-002-baseline-failures.sh`. |
| Lint, typecheck, build | The stack declares none. |
| Full suite in a clean clone | Feature suites: 449 passed, 3 failed. Regression suite: 19 passed, 0 failed. |
| Baseline check | Exit 0. Three suites are inherited. No suite is new. |
| Archetype gates | Exit 0. No gates installed. |
| Self-correction cycles | 0 |

## Inherited suites

Each suite also fails in a clean clone of the base commit `52fec04a`.

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

The first two pass in a full worktree. A clean clone has no `core.hooksPath` and no origin ref. The third fails in both places at the base.

## Security

Three informational findings. No critical or high findings. See `plan/current/security-report.md`.

## Execution evidence

Four criteria verified by running `ravintio-zero/scripts/baseline-failures.mjs` against fixtures. No criterion is `not-verifiable`. See `plan/current/verification-report.md`.

## Docs edit pass

The pass changed no doc. `ravintio-zero/tests/README.md` and `src/ravintio-zero/tests/README.md` give `prose-check.mjs` exit 0. The cycle count is 0.
