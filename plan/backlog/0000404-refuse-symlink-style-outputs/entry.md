---
title: "Backlog Entry: 0000404 - refuse a symlink at the writing style output paths"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
priority: "low"
theme: "unsorted"
---
# Backlog Entry: 0000404 - refuse a symlink at the writing style output paths

**Source feature:** 0000389-writing-standard
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-11-08
**Source retrospective:** plan/retrospectives/0000389-writing-standard-2026-11-08.md

---

## Problem

Setup writes `.claude/output-styles/ravintio-writing.md` and the `AGENTS.md` writing block with no symlink check. A symlink at either path redirects the write. See S-002 in the security report of 0000389.

## Suggested Action

Refuse a symlink at both paths in `setup.sh` and `setup.ps1`, print a fixed line, and skip the write.

## Wanted outcome

Setup on a repo with a symlink at either path writes nothing through it and exits 0 with the fixed line. A test per shell covers it.

## Why Deferred

Outside the scope of 0000389-writing-standard.
