# Verification Report - 0000438-add-step-writes-full-feature-id

**Method:** a CLI run in a scratch folder, with a copy of the real chart of initiative 0000360.

## What I started

- `node ravintio-zero/scripts/initiative-add-step.mjs --root {scratch} --title "Check run" --slug check-run --bump patch`
- The same command with `--slug Bad_Slug`.

## Criteria

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| AC-1: Full id in the row | CLI run | verified | Exit 0. The new row 42 holds `0000900-check-run` in the `Feature id` cell. |
| AC-2: Driver accepts the row | Parse the chart, test each row | verified | `FEATURE_ID` matched the new row. 0 of 42 rows fail the pattern. |
| AC-3: One pattern | Test run | verified | `test-0000438-req-001-full-feature-id.sh` passes 4 of 4. It compares the source of both patterns. |
| Bad slug stays rejected | CLI run | verified | Exit 1 with "--slug is required and must be kebab-case". The counter advanced by two, from the earlier good run only. |
