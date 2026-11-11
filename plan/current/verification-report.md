---
title: "Verification Report - 0000499-reply-times-match-clock"
summary: "What ran, and what it showed, for each acceptance criterion."
---
# Verification Report - 0000499-reply-times-match-clock

Method: ran the clock hook directly, ran the four new suites, and ran `setup.sh` and `setup.ps1` suites in scratch projects. No service started.

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 hook returns the time | `RAVINTIO_REPLY_CLOCK=13:42 node clock-context.mjs` | verified | Printed `Local time: 13:42` in `additionalContext`, exit 0. With no override it printed the clock. |
| REQ-001 AC-2 setup wires once | `setup.sh` run twice over a user `PostToolUse` entry | verified | One `clock-context` entry, the user entry kept. The PowerShell hook-filter and setup suites pass under `pwsh`. |
| REQ-001 AC-3 the pack lists the hook | Suite reads the lifecycle list and `pack-facts.json` | verified | Both name `clock-context`. `pack-facts.mjs --check` exits 0. |
| REQ-002 AC-1 standards rule | Text suite | verified | Rule `reply-time-form` names the clock read, the ban on estimates, the clock hook, and `date +%H:%M`. |
| REQ-002 AC-2 skill and reference | Text suite | verified | The initiative `SKILL.md` and `pipeline-reference.md` name the hook and the command. |
| REQ-002 AC-3 orchestrator cap | Text suite | verified | The orchestrator `SKILL.md` is unchanged at 8,987 bytes. |
| REQ-003 AC-1 3 minute gap | Stop hook on `10:03` against clock `10:00` | verified | Warning and one log line. A 2 minute gap passes. |
| REQ-003 AC-2 unknown status | Stop hook on `10:00 P4 Ship: Running: x` | verified | Status check warning, a `status:` log line, exit 0. |
| REQ-003 AC-3 valid replies | Stop hook on every allowed status | verified | No output and exit 0. |
| REQ-004 AC-1 stamped line | Watcher on a step log, clock fixed at `09:15` | verified | Line starts `09:15 I-C Run: activity: tool: Read a.txt`. |
| REQ-004 AC-2 cut | Watcher on a 400 character command | verified | The text keeps 200 characters and the stamp adds 6. |
