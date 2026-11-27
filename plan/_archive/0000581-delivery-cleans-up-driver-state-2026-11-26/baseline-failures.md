# Baseline failures

Suites that fail on the base commit. P3 reports these as inherited and stops only on other failures.

The local run did not finish. The sandbox blocks `mktemp` in `/var/folders` and writes to `/`, and the run passed its 1-hour limit before the last suite. The list holds the 12 suites that failed on the base commit `1b8907e7` before the run stopped. The finished tree failed the same 12.

- `test-0000016-pipeline-governance.sh`
- `test-0000017-req-002-ratchet-approve.sh`
- `test-0000019-req-002-component-yml-matcher.sh`
- `test-0000019-req-005-self-description-check.sh`
- `test-0000020-req-008-install-time-marker-write.sh`
- `test-0000025-req-004-setup-config-relocation.sh`
- `test-0000028-req-002-shared-module-extraction.sh`
- `test-0000028-req-006-em-dash-guard.sh`
- `test-0000029-req-001-003-boot-file-regeneration.sh`
- `test-0000031-req-004-setup-execution.sh`
- `test-0000032-req-001-bash-write-to-plan-state.sh`
- `test-0000032-req-003-inline-cleanup-of-old-record.sh`

