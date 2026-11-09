---
title: "Security Report - 0000393-session-integrity-and-guards"
summary: "Security review of the four guard and detection changes."
---
# Security Report - 0000393-session-integrity-and-guards

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| A shell write built from a variable or a script passes the new check | `ravintio-zero/hooks/enforcement/gate-write.mjs` | Low | Not mitigated. It passes today, and CI checks tracked files. Documented in `hook-enforcement.md`. |
| The new hook reads untrusted command text but never runs it | `gate-write.mjs` | Low | Mitigated. It only tokenises the text. |
| Malformed input exits 0 | `gate-write.mjs` | Low | Accepted. It matches existing behaviour. |
| Pack record JSON is parsed from a repo file | `ravintio-zero/scripts/resume-detect.mjs` | Low | Mitigated. A bad value reads as unreadable and prints one fixed line. |
| The wording script prints file paths | `ravintio-zero/scripts/check-entry-wording.mjs` | Low | Mitigated. It prints `path:line` only. |

Overall risk: low. No critical or high finding. Risks R-001 to R-004 are mitigated by tests. R-002 is accepted. No credentials, no new dependencies.
