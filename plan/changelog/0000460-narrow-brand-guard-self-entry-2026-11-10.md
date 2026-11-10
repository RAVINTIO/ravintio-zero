# Changelog (0000460-narrow-brand-guard-self-entry, 10 Nov 2026)

**Feature:** Narrow the brand guard self-entry
**Version:** set by the merge queue at merge
**PR:** 161

## What changed

- `brand-guard.sh` gains `brand_guard_skips_path`. It skips `src/ravintio-zero/tests/brand-guard-allowlist.txt` and `ravintio-zero/tests/brand-guard-allowlist.txt` by exact path.
- The guard script and the CI test `test-0000160-req-006-brand-guard.sh` both call it, so the hook and CI use one rule.
- The allowlist row that passed every line of the allowlist file is gone.
- A new suite, `test-0000460-req-001-exact-path-skip.sh`, shows that look-alike paths still fail. The 0000397 allowlist comparison drops the removed row from its base entries.
- ADR 0300 records the decision.

## Why

No decision row approved the self-entry, and it widened a fail-closed guard. Backlog entry 0000432 and the human's instruction of 2026-11-08 asked for an exact-path skip. The human chose on 2026-11-10 that the skip covers both copies.

## Deviations

- P2 ran inline without subagents, because the change is one unit.

## Validation results

- The new suite fails 6 of 14 checks before the change and passes 14 of 14 after it.
- The brand guard suites 0000160, 0000394, and 0000397 pass.

## Skipped phases

None.
