---
title: "Verification Report - 0000521-replies-name-actors-by-role"
summary: "What ran, and what it showed, for each acceptance criterion."
---
# Verification Report - 0000521-replies-name-actors-by-role

Method: the agent fed three replies to `check-reply-writing.mjs` in a scratch project. The project held the output style file. The agent also read the edited text and ran the new suites. No service started. The Stop hook runs inside the harness. The scratch run feeds it the payload shape the existing suite uses.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 boot templates hold the rule | Text suite and grep | verified | `standard-boot.md` and `codex-boot.md` name actors by role in `## Reply Conventions` |
| REQ-001 AC-2 skill and standards hold the rule | Text suite | verified | The orchestrator skill and `roadmap-standards.md` hold the rule |
| REQ-001 AC-3 orchestrator under cap | Text suite and `wc -c` | verified | 8,937 of 9,000 bytes |
| REQ-002 AC-1 a run reply with I or you gets a note | Ran the hook on `18:00 I-C Run: Complete:` plus "I fixed the test and you can merge." | verified | The output names `actor-pronoun` for "I" and for "you". Exit 0 |
| REQ-002 AC-2 other replies get no note | Ran the hook on a plain reply and on a run reply with role names | verified | Both printed nothing. Exit 0 |
| REQ-002 AC-3 prefix and code do not count | Text suite | verified | A reply with `I-C`, inline code, a fenced block, and a `>` line printed nothing |
| REQ-003 AC-1 new heading | Text suite | verified | The skill and the standards hold `Decisions for the human` and not `Decisions for you` |
| AC-5 installed copies | `sync-installed.mjs --check` | verified | Exit 0 |
