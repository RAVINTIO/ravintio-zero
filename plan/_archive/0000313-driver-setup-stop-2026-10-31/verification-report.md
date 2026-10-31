---
title: "Verification Report - 0000313-driver-setup-stop"
summary: "Execution evidence for each acceptance criterion."
---
# Verification Report - 0000313-driver-setup-stop

## What was started

A temporary git repository with a two-step initiative and a stub `claude` that changes files and moves `position`. The real `ravintio-zero/scripts/initiative-run.mjs` ran against it with `node`. The repository was deleted afterwards.

## Criteria

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1: skill change stops the driver | Ran the driver. The stub changed `ravintio-zero/skills/ravintio-ship/SKILL.md`. | verified | Exit 1. A line begins `I-D Advance: Setup:`. Step 2 did not start. The lock file was gone. The suite case in `test-0000313-req-001` repeats it. |
| REQ-001 AC-2: test-only change gives no stop | `test-0000313-req-001` AC-2 fixture, run with `bash` | verified | Exit 0. No `Setup:` line. Both steps ran. |
| REQ-001 AC-3: both stops give one line | Ran the driver. The stub changed `initiative-run.mjs`, `hooks/h.sh`, and the ship `SKILL.md`. | verified | Exit 1. One line began `I-D Advance: Restart: Setup:` and named all three files once, restart file first. The line ended with the log path. |
| REQ-002 AC-1, AC-2: the skill names the stop and the guards | Ran `test-0000313-req-002` and read the diff | verified | Section `## Stops` holds `Setup:`, `planned stop`, `Confirmation:`, the exact-command rule, `.claude/settings.json`, new driver and watcher. The skill has 111 lines. |
| REQ-003 AC-1, AC-2: standards and manifest | Ran `test-0000313-req-003` and read the diff | verified | `#### Setup stop` holds both lines and each path. `component.yml` lists the stop. |

## Not verifiable

- A live `Setup:` rerun by the initiative skill needs a human session. The skill text is checked by tests only, so the behaviour is `unverified (docs only)`. Step 1 ends on the old driver, so the first live use is step 2.
