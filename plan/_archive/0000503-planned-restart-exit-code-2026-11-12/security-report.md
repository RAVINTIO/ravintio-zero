---
title: "Security Report - 0000503-planned-restart-exit-code"
summary: "Review of the exit-code change in the initiative driver."
---
# Security Report - 0000503-planned-restart-exit-code

**Overall risk:** low

The change adds a `Restart` class and an exit code to `src/ravintio-zero/scripts/initiative-run.mjs`. It reads no new input and runs no new command.

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| Injection: none. The planned flag depends on a fixed prefix of a line the driver builds. | `isRestartLine` in `initiative-run.mjs` | Low | Not applicable |
| Credentials: none read or written | `initiative-run.mjs` | Low | Not applicable |
| Path traversal: no new path built | `initiative-run.mjs` | Low | Not applicable |
| Dependencies: none added | `component.yml` | Low | Not applicable |
| Data exposure: the stop line text is unchanged | `main()` exit handler | Low | Not applicable |

Risk register R-001 (a failure exits 75): mitigated. The `stop.failed` flag turns a later failure into exit 1, and `test-0000503-req-001-003-restart-exit.sh` pins it.
