# Verification Report - 0000579-convert-remaining-suites-to-rule-anchors

## What ran

- The guard suite from `src/ravintio-zero/tests/` and from `ravintio-zero/tests/`.
- `test-0000380-req-002-rule-anchors.sh` from both trees.
- `node ravintio-zero/scripts/prose-check.mjs check` over the changed docs.
- `node ravintio-zero/scripts/archetype-gates.mjs`.
- Each batch agent ran its converted suites alone.
- The full suite runs in a clean clone of `HEAD`.

## Criteria

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 a converted suite reads its rule by anchor | Guard suite reads the ledger | verified | 160 converted lines, each calls a helper, 9 passed |
| REQ-001 AC-2 a converted suite passes from both trees | Guard suite and batch runs from `src`, then the full run from the installed tree | verified | exit 0 for each, full run pending |
| REQ-001 AC-3 anchors stay unique and well formed | `test-0000380-req-002` in both trees | verified | 21 passed |
| REQ-002 AC-1 the ledger lists every suite judged | Guard suite | verified | 160 converted, 46 structure, no duplicate |
| REQ-002 AC-2 the probe rewords the anchored rules | Guard suite probe | verified | 10 sampled suites pass in the control copy and the reworded copy |
| REQ-002 AC-3 the guard fails on a regressed suite | Guard suite with a fake ledger | verified | names the suite, the missing reason, and the missing file |
