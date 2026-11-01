---
title: "Backlog Entry: 0000271 - gate-write checks file writes made from the shell"
summary: "A retrospective finding, filed for pickup at a future discovery run."
status: "open"
priority: "medium"
theme: "unsorted"
---
# Backlog Entry: 0000271 - gate-write checks file writes made from the shell

**Source feature:** none (initiative 0000238 retrospective)
**Source phase:** none (I-E Delivery)
**Deferral source:** retrospective `plan/retrospectives/0000238-backlog-clearance-two-initiative-2026-10-29.md`
**Date filed:** 2026-10-29

---

## Problem

The `gate-write` hook runs on the Write and Edit tools only. Step sessions in this initiative wrote files with shell heredocs and `sed -i` instead, for example `cat > plan/current/feature-brief.md <<'EOF'` in step 15 (`plan/.initiative-logs/step-15.log`). Those writes never reach the hook.

All the writes seen in this initiative went to paths the hook allows. A shell write to a gated path would pass with no check.

## Suggested Action

- Add a PreToolUse check on Bash that finds redirects, `tee`, and `sed -i` aimed at in-project paths, and applies the `gate-write` rules to them.
- This change makes the guard stricter. It must not let any write pass that the hook blocks today.

## Wanted outcome

A shell write to a gated path meets the same rules as a Write tool call. Tests check these conditions:

- A Bash `cat >` to a gated `src/` path with no design is blocked.
- A Bash write to `plan/backlog/` still passes.
- Every case that `gate-write` blocks today stays blocked.

## Why Deferred

The initiative retrospective found it at I-E Delivery. No step remained to take it.
