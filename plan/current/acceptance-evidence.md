---
title: "Acceptance Evidence - 0000444-step-reads-its-queue-items"
summary: "Results of P3 for the PR description."
---
# Acceptance Evidence - 0000444-step-reads-its-queue-items

## Checks

- New suite: 26 of 26 checks pass. It passed 7 of 26 before the change.
- Full suite in 4 shards: 403 feature suites and 19 regression suites pass, 0 fail.
- Baseline check: no new failing suite.
- Self-corrections: 1, the CodeQL escape fix.
- Consistency check and `sync-installed.mjs --check`: clean.

## Security

One high finding, from CodeQL: an escape that missed the backslash. The fix is in `initiative-queue.mjs` and the suite still passes. Four low findings, each mitigated. See `plan/current/security-report.md`.

## Execution evidence

- `initiative-queue.mjs list --step 25` printed the queued item. `list --step 26` printed none.
- `check --step 25` exited 1 and named the item. `check --step 26` exited 0.
- The driver prompt for a step with a named item lists its folder name and no content.
- Not verifiable: a live `claude` resume. The stub suite covers the argument build only.

## Docs edit pass

Changed docs: `docs/architecture-overview.md`, `docs/decisions-index.md`, `docs/adr/0307-steps-read-their-queue-items.md`, and the changelog. One inline review cycle. No change needed. `prose-check.mjs check` exits 0. A step session spawned no subagent for it.
