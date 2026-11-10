---
title: "Verification Report - 0000460-narrow-brand-guard-self-entry"
summary: "What ran, and what it showed, for each acceptance criterion."
---
# Verification Report - 0000460-narrow-brand-guard-self-entry

Method: ran `ravintio-zero/scripts/brand-guard.sh` on a scratch tree and on the tracked files of this repo. No service started.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| AC-1 exact paths only | Guard run on a scratch tree with both allowlist paths and two look-alikes, each holding the word | verified | Exit 1. It reported `ravintio-zero/tests/brand-guard-allowlist.txt.bak:1` and `x/brand-guard-allowlist.txt:1`. It reported neither allowlist path |
| AC-2 no self-entry | Read the shipped allowlist, and ran the CI brand test | verified | No row has a bare-dot line regex that matches an allowlist path. `test-0000160-req-006-brand-guard.sh` passes 5 of 5 |
| AC-3 one rule | Read the script, its main function, and the CI test | verified | All three call `brand_guard_skips_path`. `test-0000460-req-001-exact-path-skip.sh` passes 14 of 14 |
| AC-4 hook and CI share the rule | Ran `brand-guard.sh` on every tracked file under `src`, `ravintio-zero`, `docs`, and `plan/changelog` | verified | Exit 0, so the shipped tree passes the guard that `pre-push` runs. `test-0000394-req-004-brand-guard-before-push.sh` passes 12 of 12 |
