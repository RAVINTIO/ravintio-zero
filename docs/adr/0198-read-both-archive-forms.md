---
title: "ADR 002: Read both archive folder forms"
summary: "New deliveries archive to an -initiative- folder, and the driver's delivery check reads both forms."
status: "accepted"
version: "0.1.0"
component: "ravintio-zero"
feature: "0000192-rename-runner-lock-and-archive"
---
# ADR-0198 - Read both archive folder forms

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000192-rename-runner-lock-and-archive
**Component:** ravintio-zero
**Date:** 26 Oct 2026

## Context

I-E Delivery archives an initiative to the old `-roadmap-` archive folder form. The driver's delivery check looks for that prefix to decide a run has finished. ADR-0193 chose a clean break with a migration for its renames. The archive folder holds history, and 0000189 kept `plan/_archive/` out of scope for edits. `0000168-backlog-clearance-roadmap-2026-10-25` already uses the old form.

## Decision

I-E Delivery archives to `plan/_archive/{id}-{slug}-initiative-{date}/`. The delivery check accepts a folder that starts with `{id}-{slug}-initiative-` or `{id}-{slug}-roadmap-`. Existing folders keep their names, and no migration runs.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Rename existing archive folders | One form only | Rewrites history and breaks links into the archive | History stays unedited |
| Accept the new form only | Simpler check | A consumer with an initiative delivered under the old form would rerun its last step | Rerunning a delivered step is the worst outcome |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | The driver keeps one legacy prefix, and the old-name guard allowlists the driver |

## Consequences

**Positive:**
- No consumer needs a migration.
- History stays as the author wrote it.

**Negative:**
- `plan/_archive/` holds two folder forms for delivered initiatives.

**Risks:**
- The legacy prefix outlives its use. It costs one string in the driver.
