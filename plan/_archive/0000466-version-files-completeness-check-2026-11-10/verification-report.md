# Verification report - 0000466-version-files-completeness-check

Method: ran the test script on the source and installed copies, and removed one list line to check that the test fails.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 | CLI: ran the suite on the real repo | verified | Exit 0 with the shipped list |
| REQ-001 AC-2 | CLI: fixture with an unlisted `component.yml`, and the real list with the `? src/ravintio-zero/component.yml` line removed | verified | Exit 1 and `omitted: src/ravintio-zero/component.yml` |
| REQ-001 AC-3 | CLI: fixture list with a required entry whose file is absent | verified | Exit 1 and `missing: gone/component.yml` |

I restored the list after the removal check, and `git status` was clean.
