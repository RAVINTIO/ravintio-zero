---
title: "ADR 001: Stack choice"
summary: "The feature stays in Node.js and Bash with the pack's own test suites, and adds no dependency."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000197-merge-guard-block-message"
---
# ADR-0201 - Stack choice

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000197-merge-guard-block-message
**Component:** ravintio-zero
**Date:** 2026-10-27

## Context

The change edits message strings in `merge-guard.mjs` and the Bash test for it. The design declares the stack as Node.js and Bash with the pack's test runners.

## Decision

Edit the existing hook and test only. Change message text and nothing in the control flow. Add no library or service.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Skip heredoc bodies and quoted text | No false block on file writes | A command can run text it first writes to a file, so the guard weakens | The human rejected it at chart on 2026-10-26 |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | One hook, one test, and docs |

## Consequences

**Positive:**
- The agent learns the real reason and the fix from the message.

**Negative:**
- The agent still needs a second call to write the file.

**Risks:**
- A message edit could touch control flow. The existing suite guards the block set.

## Related ADRs

- None

## Supersedes

None.

## Superseded By

None.
