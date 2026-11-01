# Verification report - 0000320-quiet-session-start

I ran the two hooks, the script, and the Stop hook in a throwaway project under a temporary folder. The folder was removed afterwards.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| req-001 AC-1: first prompt gets the instruction | Hook run with session A | verified | Instruction printed, record holds A |
| req-001 AC-2: second prompt gets none | Hook run again with session A | verified | No output |
| req-001 AC-3: new session gets it again | Hook run with session B | verified | Instruction printed, record holds B |
| req-001: no session id | Hook run with no id | verified | Instruction printed, no record written |
| req-002 AC-1: quiet at the same version | Script run with a `not applicable` row | verified | No finding |
| req-002 AC-2: pack update brings it back | Same row, newer version | verified | `pending migration: 0007` |
| req-002 AC-3: true condition reports at once | `Detect:` target created | verified | `pending migration: 0007` |
| req-003 AC-1: done row quiet after update | `done` row, newer version, condition true | verified | No finding |
| req-003 AC-2: migrator leaves the pack unchanged | Read the skill text and ran the suite | verified | Skill appends to the ledger and edits nothing in the pack |
| req-003 AC-3: migration 0006 copies old records | Helper run on a fixture, rerun | verified | One row for each record, no duplicate on rerun |
| req-004 AC-1: prefixed final reply gives no warning | Stop hook with an unprefixed note earlier | verified | No output, no log |
| req-004 AC-2: unprefixed final reply warns | Stop hook | verified | Warning printed, log quotes that reply |
| req-004 AC-3: tool_use end gives no warning | Stop hook, no final message | verified | Exit 0, no output, no log |

In this repo, `resume-detect.mjs` still lists migrations 0004 and 0005. The ledger rows carry pack version 0.46.0 and `component.yml` holds 0.45.0 until the version bump at P4. P4 repeats this check.
