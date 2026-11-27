# Verification report - 0000580-log-non-tdd-units

Started: no service. Each check ran a script from the repo root against a fixture log in a scratch folder.

| Requirement | Criterion | Method | Outcome | Evidence |
|-------------|-----------|--------|---------|----------|
| REQ-001 | AC-1 class defined | `test-0000580-req-001-docs-class.sh` reads rule `dispatch-unit-classes` | verified | 5 passed, 0 failed |
| REQ-001 | AC-2 marker rule defined | The same suite reads rule `dispatch-docs-markers` | verified | the rule names both markers, the script flag, and 0000410 |
| REQ-002 | AC-1 class on a marker | `build-log-mark.mjs GREEN "V1 docs" --class docs` | verified | exit 0, line `- GREEN: V1 docs (docs, {time})` |
| REQ-002 | AC-2 old form kept | `test-0000580-req-002` runs `RED` with no `--class` | verified | line `- RED: U2 thing ({time})` |
| REQ-002 | AC-3 bad class refused | `build-log-mark.mjs RED V3 --class "a,b"` | verified | exit 2, the log is unchanged |
| REQ-003 | AC-1 docs unit with markers | `build-log-check.mjs` on a log with `RED:`, `GREEN:`, `Done:` | verified | no finding names V1 |
| REQ-003 | AC-2 docs unit without markers | `build-log-check.mjs` on a log with only a `docs` `Done:` line | verified | two findings name the missing `RED:` and `GREEN:` lines |
| REQ-003 | AC-3 older line | `test-0000580-req-003` | verified | 6 passed, 0 failed |
| REQ-004 | AC-1 docs row | `workflow-metrics.mjs` on the V1 log | verified | row `\| docs \| inline \| 1 \| 0 \|` |
| REQ-004 | AC-2 unclassified kept | `test-0000580-req-004` | verified | 5 passed, 0 failed |

Observation: the finding for a `docs` unit still reads `inline "Done:" line has no ...`. The text names the old trigger. It fails the right lines, so the step leaves the wording alone.

Not verifiable: the full suite, which cannot finish in this sandbox. See the acceptance evidence.
