---
title: "Verification Report - 0000393-session-integrity-and-guards"
summary: "Execution evidence for each acceptance criterion."
---
# Verification Report - 0000393-session-integrity-and-guards

Each hook ran against a scratch project in a temporary folder. The resume check ran in a scratch repo.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 | Hook trigger | verified | Bash `cat >` to `src/comp/x.js` with no design: exit 2 |
| REQ-001 AC-2 | Hook trigger | verified | Heredoc to `plan/backlog/x/entry.md` with a `>` body line: exit 0 |
| REQ-001 AC-3 | Existing suites | verified | All gate-write suites pass |
| REQ-001 extra | Hook trigger | verified | `tee` and `sed -i` to a gated path: exit 2. `/dev/null`: exit 0 |
| REQ-002 AC-1 | Hook trigger | verified | `--git-dir` and `--work-tree` with `$F`: exit 2 |
| REQ-002 AC-2 | Hook trigger | verified | `git add {-f,x}`: exit 2 |
| REQ-002 AC-3 | Hook trigger | verified | `git add src/a.js`: exit 0 |
| REQ-003 AC-1 | CLI run | verified | Pack 0.37.0, about 0.4.0, record 0.37.0: no pack finding |
| REQ-003 AC-2 | CLI run | verified | Record 0.36.0: one finding naming the record |
| REQ-003 AC-3 | Text check | verified | Tests read the policy and template text |
| REQ-004 AC-1 | CLI run | verified | A banned line: exit 1 with `file:line` |
| REQ-004 AC-2 | CLI run | verified | Clean fixture: exit 0 (suite test) |
| REQ-004 AC-3 | Text check | verified | Skill Step 6 runs the check before Step 7 |
