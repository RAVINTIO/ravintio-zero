# Verification report - 0000384-plan-checks

Method: ran each script and suite in the worktree at `feat/0000384-plan-checks`. No service was started.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 | Ran `consistency-check.mjs` on an ADR that names `command_not_found_handle` with no `Oldest shell:` line | verified | Exit finding names the ADR and the feature |
| REQ-001 AC-2 | Added the `Oldest shell:` line and reran | verified | No check 9 finding |
| REQ-002 AC-1, AC-2 | `test-0000384-req-002-003-templates.sh` pipes a write envelope to `gate-write.mjs` | verified | Listed path exits 0, unlisted path exits 2 |
| REQ-003 AC-1 to AC-3 | `test-0000384-req-001-004-plan-checks.sh` and `test-0000384-req-002-003-templates.sh` | verified | 33 and 8 assertions pass |
| REQ-004 AC-1, AC-2 | Same suite, fixture plans in temp folders | verified | Shared port in one batch fails, older plan passes |
| REQ-005 AC-1 | Counted `docs/adr/` and archived ADR files | verified | 273 numbered files, 0 archived ADR files |
| REQ-005 AC-2 | `test-0000384-req-005-adr-migration.sh` compares files and index rows | verified | 24 assertions pass |
| REQ-005 AC-3 | `migrate-adr-home.sh`, `.ps1`, and `.mjs` with `--dry-run --include-current` | verified | `Dry run: 0 change(s).` for each |
| REQ-006 AC-1 to AC-3 | `test-0000384-req-006-human-settings.sh` with a stub `gh`, then the script on the real chart | verified | 16 assertions pass. The real chart has no row and prints `none`. |
| NFR-001 idempotence | Reran the migration after it wrote | verified | 0 changes |
| NFR-002 run time | Suite timing on a 50-file plan | verified | Under 2 s |

Not verifiable here: the Windows CI job for the `.ps1` wrapper. `pwsh` ran the wrapper locally and printed the same dry-run result.
