---
title: "Acceptance Evidence - 0000462-tests-without-git-identity"
summary: "Results of the checks, the security review, and execution verification."
---
# Acceptance Evidence - 0000462-tests-without-git-identity

## Checks

- New suites: `test-0000462-req-001-git-identity-isolation.sh` passes 11 of 11 inside the isolation. It failed 6 of 6 before the helper existed. `test-0000462-req-002-bom-first-line-readers.sh` passes 9 of 9. It failed 1 of 9 before the `setup.sh` fix. The `.ps1` twin passes 4 of 4 under `pwsh`.
- Full suite in a clean clone of `HEAD`: 389 passed, 2 failed, 19 regression suites passed. Both failures also fail on the base commit (`baseline-failures.md`). The baseline check exits 0.
- A full run in this tree with the isolation on: 389 passed, 0 failed. No existing suite needed an identity fix.
- `sync-installed.mjs --check`: exit 0.
- `archetype-gates.mjs`: no gates installed.
- `prose-check.mjs` on the changed docs: exit 0.
- OS gap: local macos, CI ubuntu and windows. The PowerShell suite ran under `pwsh` 7 only, not Windows PowerShell 5.1.
- Self-corrections: 0.

## Security

No critical or high findings. Two low findings, both mitigated. See `plan/current/security-report.md`.

## Execution

Reverting each PR #136 fix in a scratch copy made the local suite fail on both defects. See `plan/current/verification-report.md`. No criterion is not-verifiable.

## Docs edit pass

Changed docs: `docs/architecture-overview.md`, `docs/decisions-index.md`, `src/ravintio-zero/tests/README.md`, ADR 0303, and the changelog. The pass ran inline in 1 cycle. `prose-check.mjs` exits 0.

## Deviation

The BOM suite found a defect that the backlog entry did not name. `setup.sh` copied a pack `CLAUDE.md` that starts with a BOM to `ravintio-overrides/instructions/`. The step fixed it in `preserve_developer_boot_file`.
