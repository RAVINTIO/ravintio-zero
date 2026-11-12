---
title: "Postmortem: 2026-11-12 - Missing guard passed the hook check"
summary: "A blameless record of why a missing guard script passed the hook check, and the actions that close the gap."
status: "closed"
---
# Postmortem: 2026-11-12 - Missing guard passed the hook check

> Path: `plan/postmortems/2026-11-12-missing-guard-passed-hook-check.md`. Written by `ravintio-postmortem`.

**Trigger:** P2 self-correction
**Feature:** 0000507-hook-check-after-setup
**Date:** 2026-11-12

## Summary

The first version of `hook-check.mjs` passed a guard whose script was missing. Execution verification in P3 found it before ship, so no defect escaped.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-11-12 | The design and ADR-0339 set exit 0 and exit 2 as a pass | `docs/adr/0339-hook-check-pass-rule.md` |
| 2026-11-12 | The first script and suite passed with 25 checks | commit 9ef63a6e |
| 2026-11-12 | P3 execution verification deleted `gate-write.mjs` in a copy and the check reported 15 passed | `plan/current/verification-report.md`, section "Finding from execution" |
| 2026-11-12 | The agent added the launcher-line rule and a test | commit 27efb2de |

First missed chance to catch it: P1 Plan. REQ-002 listed the exit codes. It left out the `guard-run.mjs` exit 2 for a script it cannot run.

## 5 whys

1. A missing guard script passed the hook check.
2. `guard-run.mjs` fails closed with exit 2 for a script it cannot run. The check counts exit 2 as a pass.
3. The pass rule in REQ-002 and ADR-0339 named the exit code. It did not name the stderr line that tells the two causes of exit 2 apart.
4. P1 read the guard's block behaviour but not the launcher's failure path in `src/ravintio-zero/hooks/enforcement/guard-run.mjs`.
5. No P1 step asks a planner to list every way the checked component can produce the pass signal.

**Gap:** The plan skill has no step that lists each way the checked component produces a pass signal.

## Actions

| Type | Action | Status | Owner | Lives in | Verified by | Ref |
|------|--------|--------|-------|----------|-------------|-----|
| corrective | Fail any hook whose stderr holds a `[RAVINTIO] guard-run:` line | done | step 55 | `src/ravintio-zero/scripts/hook-check.mjs` | `test-0000507-req-001-hook-check.sh` | commit 27efb2de |
| preventive | none, because the launcher rule and its test now pin the case, and a wider plan-skill step needs a human decision | none | none | none | none | none |
| detective | none, because P3 execution verification found the defect before ship | none | none | none | none | none |
