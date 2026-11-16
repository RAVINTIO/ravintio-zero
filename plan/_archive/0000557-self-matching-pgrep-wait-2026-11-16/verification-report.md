# Verification report - 0000557-self-matching-pgrep-wait

Target type: CLI script and skill text. The agent ran the test and a negative probe.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| AC-1 P0 names the wait | Ran `test-0000557-req-001-safe-suite-wait.sh` | verified | Exit 0. Step 15 holds the end marker, the process id, and the ban. |
| AC-2 P3 names the wait | Same run | verified | The fast batch holds the same three terms. |
| AC-3 No unsafe wait | Ran the test, then piped one line without `Never` through the same `grep` pair | verified | The suite passes 7 of 7. The probe printed the bad line, so the check catches it. |
| NFR-001 Size cap | Ran `test-0000391-req-008-standard-text.sh` | verified | No failure. The validate skill holds 162 lines against 200. |
