---
title: "Retrospective: 2026-11-16 - Diff reader cause in the scan"
summary: "A blameless review of step 33, which added a change shapes cause to the plan scan."
status: "open"
---
# Retrospective: 2026-11-16 - Diff reader cause in the scan

**Mode:** run
**Subject:** 0000577-plan-lists-change-shapes
**Date:** 2026-11-16

## Summary

The step added one cause, merged two others to hold the 21-line cap, and added one suite. The full run passed apart from the inherited `test-0000450-req-004-report-format.sh` and one PowerShell suite that passed alone.

## What helped

- The step 27 archive gave a template for every artifact (plan/_archive/0000571-scan-cause-skill-wide-grep-pins-2026-11-16/design.md).
- The discovery count of 21 lines showed the cap problem before any edit (plan/_archive/0000577-plan-lists-change-shapes-2026-11-16/discovery.md, Step inputs).

## What slowed the work

- The baseline and full suites ran at once, and `test-0000039-req-001-003-ps1-setup-hardening.ps1` failed once under load (plan/_archive/0000577-plan-lists-change-shapes-2026-11-16/acceptance-evidence.md).
- `build-log-mark.mjs` wrote markers after the closing rule of the phase block, so the agent moved them by hand.

## Keep

- Merging two cause lines holds the scan cap without a change across six suites.

## Change

- Place a `build-log-mark.mjs` marker inside the open phase block.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Place markers inside the open phase block | the coordinator | `ravintio-zero/scripts/build-log-mark.mjs` | a test with a closed block above `## Summary` | not filed |
