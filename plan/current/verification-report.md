# Verification report - 0000573-require-unit-reports

Target type: hook and gate. The agent ran the requirement test and read the rule text.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| AC-1 Four fields | Ran `bash ravintio-zero/tests/test-0000573-req-001-unit-report-fields.sh` | verified | Exit 0, 3 passed. The rule names the RED line, GREEN line, commit hash, and deviation. |
| AC-2 Reject and resume once | Same run, then read `ravintio-zero/standards/agent-dispatch-standards.md:78-84` | verified | The rule says the orchestrator rejects a report that lacks a field and resumes the unit once. |
| NFR-001 Copies match | Same run, `cmp` of both copies | verified | The copies are identical. |

Runtime behaviour of an orchestrator facing an empty report is `unverified (docs only)`. The rule is prose, so the test checks the rule text.
