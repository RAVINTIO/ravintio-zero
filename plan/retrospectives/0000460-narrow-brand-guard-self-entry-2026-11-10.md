---
title: "Retrospective: 2026-11-10 - narrow the brand guard self-entry"
summary: "A blameless review of step 34, which replaced an allowlist self-entry with an exact-path skip."
status: "open"
---
# Retrospective: 2026-11-10 - narrow the brand guard self-entry

**Mode:** run
**Subject:** 0000460-narrow-brand-guard-self-entry
**Date:** 2026-11-10

## Summary

The brand guard now skips its two allowlist files by exact path, and the allowlist holds no self-entry. The step ran inline in five phases with two self-corrections in the new suite.

## What helped

- The queued instruction and the chart decision row named both paths, so P0 had no open question (`plan/_archive/0000460-narrow-brand-guard-self-entry-2026-11-10/discovery.md`).
- One shared function let the hook and CI test follow one rule, and a test pins it (`test-0000460-req-001-exact-path-skip.sh`, AC-3).

## What slowed the work

- The baseline suite run starts late and takes about 13 minutes, so P3 waited (build log, P2 and P3 blocks).
- The 0000397 allowlist comparison pinned the base entries, so it needed an edit when the row left (`test-0000397-req-005-guards-cover-both.sh`).
- A gate hook blocked the first write of the sentinel and the discovery file in one command. The Bash write needs the sentinel in an earlier call.

## Keep

- Pin a security narrowing with a test that plants look-alike paths (`test-0000460-req-001-exact-path-skip.sh`).

## Change

- Start the baseline run as the first P0 action (build log, P3 block).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Start the baseline run first | orchestrator | `orchestrator-p0-start-actions.md` | A test that reads the step order | `plan/backlog/0000476-start-baseline-first/entry.md` |
