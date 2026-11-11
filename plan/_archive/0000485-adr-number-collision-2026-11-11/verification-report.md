---
title: "Verification Report - 0000485-adr-number-collision"
summary: "What ran, and what it showed, for each acceptance criterion."
---
# Verification Report - 0000485-adr-number-collision

Method: ran the two new suites. Each builds real git repos and merges a base into a PR branch. It then runs the module, or the real `merge-queue.mjs` against a fake `gh` and a bare remote. No service started.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 ADR renumbered | Module suite, world `adr` | verified | `0301-feat-a.md` became `0302-feat-a.md`, with heading, title, File line, and index row at 0302. The base ADR kept 0301 |
| REQ-001 AC-2 references and counter | Module suite, world `adr` | verified | `note.md` cited `ADR-0302` and `docs/adr/0302-feat-a.md`, `Version 0.301.0` stayed, and the counter held 0303 |
| REQ-001 AC-3 no collision | Module suite, world `clean` | verified | The module returned `[]`, the tree had no change, and HEAD did not move |
| REQ-002 AC-1 backlog entry | Module suite, world `adr` | verified | The PR folder became `0000011-feat-e`, the base kept `0000010-base-e`, and the index listed both |
| REQ-002 AC-2 clean merge | Queue suite, world `apart` | verified | Step 2 merged with exit 0 and printed no ADR renumber line for distinct numbers |
| REQ-002 AC-3 shared-file resolution | Queue suite, world `same` | verified | Step 2 printed `resolved: docs/decisions-index.md`, `renumbered: adr 0301 -> 0302`, and `renumbered: backlog 0000010 -> 0000011`, then merged. The base held `0302-step-2.md` and counter 0303 |
