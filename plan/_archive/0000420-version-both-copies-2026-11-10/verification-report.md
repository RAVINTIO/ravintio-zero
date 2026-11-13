# Verification report - 0000420-version-both-copies

**Method.** I ran the new suite before and after the change. I ran the 0000378 list test and the four queue suites, then the full suite in a clean clone in 4 shards.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 optional entries | `test-0000420-req-001` | verified | `set` and `check` pass with a missing optional file. The present optional file holds the new version |
| REQ-001 AC-2 required entries | `test-0000420-req-001` | verified | A missing required file fails with `file not found: product.yml` |
| REQ-001 AC-3 the shipped list | `test-0000420-req-001`, `test-0000378-req-001` | verified | The list names `? src/ravintio-zero/component.yml` and the three required files |
| Optional path outside the root | `test-0000420-req-001` | verified | It fails with `path outside the root` |

**Not verifiable.** The queue bump on a live step PR. Step 21's merge shows it.

**Test run.** 395 suites, 393 passed. `test-0000037-req-004` and `test-0000318-req-004` match `baseline-failures.md`.
