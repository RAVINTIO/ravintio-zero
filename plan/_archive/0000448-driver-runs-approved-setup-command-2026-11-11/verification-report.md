# Verification report - 0000448-driver-runs-approved-setup-command

## What ran

The driver ran as a real `node` process against throwaway git repos. A stub `claude` and a stub merge queue replaced the network. The helper ran against the real chart `plan/current-initiative/initiative.md`.

## Criteria

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 valid row | CLI: import the helper and read the real chart | verified | Returned `ravintio-zero/setup.sh` with args `claude-code` and `--strict-orchestrator` |
| REQ-001 AC-2 no row | Suite `test-0000448-req-001` | verified | `null` for no table and for a non-setup row |
| REQ-001 AC-3 other forms | Suite `test-0000448-req-001` | verified | `null` for 10 other forms and for two different commands |
| REQ-002 AC-1 valid row continues | Suite `test-0000448-req-002`, serial and concurrent | verified | Setup log holds one line with the args. Step 2 started or merged. Exit 0 |
| REQ-002 AC-2 stops | Suite `test-0000448-req-002` | verified | No row, bad row, and failing command each exit 1 with the `Setup:` line and no step 2 |
| REQ-002 AC-3 restart | Suite `test-0000448-req-002` | verified | The command ran once. The `Restart:` line printed. Exit 1 |
| REQ-003 AC-1 standards text | Suite `test-0000448-req-003` | verified | The `Setup stop` section names the helper, the ran line, and the failure sentence |
| REQ-003 AC-2 skill text | Suite `test-0000448-req-003` | verified | `Stops` says the driver runs the command and a `Setup:` line means it did not |

## Not verifiable

The driver did not run the real `setup.sh`. The suites use a stub `setup.sh`, because the real one rewrites hook wiring in the repo.
