---
title: "Security Report - 0000444-step-reads-its-queue-items"
summary: "Security review of the queue helper and the driver prompt change."
---
# Security Report - 0000444-step-reads-its-queue-items

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|-----------|
| Item text could steer a step session through the prompt | `src/ravintio-zero/scripts/initiative-run.mjs`, `queueSentence` | Low | The sentence holds only folder names that match `^[A-Za-z0-9._-]{1,80}$` and the queue path. The suite feeds a hostile name and body and checks both stay out |
| Item folder or file as a symlink reads data outside the queue | `src/ravintio-zero/scripts/initiative-queue.mjs`, `namedItems` | Low | The helper checks `lstat` on `plan`, the queue folder, each item folder, and `item.md`, and skips a link |
| Destination path traversal | `initiative-queue.mjs`, `namedItems` | Low | The helper refuses an absolute path, a `..` segment, and a path over 300 characters. It only compares the path with `git diff` output and never opens it |
| Regular expression built from item data | `initiative-queue.mjs`, `matcher` and the report pattern | Low | The destination is escaped. The name matches NAME before use. The input is under 64 KB |
| Shell injection | `initiative-queue.mjs`, `git` | Low | The helper calls `git` with an argument array and never uses a shell. The base ref comes from the command line or the chart |
| Credentials | all changed files | none | None present |
| Dependencies | all changed files | none | No new library or service |

## Cross-reference to the risk register

- R-001 (prompt steering): mitigated.
- R-002 (check fails a step that needs no commit): mitigated by the report line.
- R-003 (`{id}` never matches): mitigated by the seven-digit match, and the suite covers it.

## Overall risk

Low. No critical or high finding. No guard changes.
