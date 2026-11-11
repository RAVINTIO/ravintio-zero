---
title: "Verification Report - 0000489-question-only-for-questions"
summary: "What ran, and what it showed, for each acceptance criterion."
---
# Verification Report - 0000489-question-only-for-questions

Method: ran the Stop hook on three replies in a scratch project at `/tmp/s46p` and read the text files. The two new suites run the same cases against a temporary project. No service started.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 standards rule | Text suite | verified | Rule `icrun-question-real` names the question mark, the waiting step, and the wakeup |
| REQ-001 AC-2 status text | Text suite | verified | `SKILL.md` and `pipeline-reference.md` say `Question:` asks the human, and `SKILL.md` keeps `exception stop` |
| REQ-001 AC-3 caps | Text suite | verified | The orchestrator is 8,987 bytes of 9,000. All skills total fewer than 1,720 lines |
| REQ-002 AC-1 false question | Hook run on `07:49 I-C Run: Question: step 31 is partway through` | verified | It printed a `Question check` warning, exit 0, and wrote `question: ` to the miss log |
| REQ-002 AC-2 real question | Hook run on a `Question:` line that ends with `?` | verified | No output, exit 0, no log line |
| REQ-002 AC-3 other statuses | Hook run on a `Blocked:` line with no mark | verified | No output, exit 0. The suite also covers `Complete:` and a missing prefix |
